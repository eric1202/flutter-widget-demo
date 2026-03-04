import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

/// ========================================================================
/// QrScannerPage - 基于 camera 插件的二维码扫描教程
/// ========================================================================
///
/// 本页面 **完全基于 Flutter 官方 camera 插件** 实现二维码扫描功能，
/// 不依赖 mobile_scanner、qr_code_scanner 等任何第三方扫码库。
///
/// 【实现思路】
///
///   camera 插件本身只负责「相机预览」和「获取图像数据」，
///   并不包含二维码识别能力。因此完整的扫码流程分为两步：
///
///   第 1 步：通过 controller.startImageStream() 获取实时视频帧
///   第 2 步：将视频帧数据发送到「解码器」进行二维码识别
///
///   解码器可以是：
///     a) 原生端 (通过 MethodChannel)
///        - iOS: 使用 AVFoundation 的 CIDetector 或 Vision 框架
///        - Android: 使用 ML Kit 或 ZXing
///     b) Dart 侧的 Isolate（使用纯 Dart 的二维码解码库）
///
/// 【本教程包含的知识点】
///
///   1. CameraController 的初始化与生命周期管理
///   2. startImageStream / stopImageStream 的使用
///   3. CameraImage 数据结构详解
///   4. 扫码 UI 的完整构建：
///      - 相机预览层
///      - 半透明遮罩层（仅扫描框区域透明）
///      - 扫描框四角装饰
///      - 扫描线动画（上下移动的渐变线条）
///   5. 帧率控制与性能优化策略
///   6. MethodChannel 桥接原理说明
///
/// 【CameraImage 数据结构】
///
///   当 startImageStream 回调触发时，每帧返回一个 CameraImage 对象：
///
///   CameraImage {
///     planes: List<Plane>    → 图像数据平面
///       Plane {
///         bytes: Uint8List   → 原始像素数据
///         bytesPerRow: int   → 每行字节数
///         bytesPerPixel: int → 每像素字节数 (可能为 null)
///       }
///     width: int             → 图像宽度 (像素)
///     height: int            → 图像高度 (像素)
///     format: ImageFormatGroup → 图像格式
///   }
///
///   iOS 上通常使用 bgra8888 (单平面，4字节/像素)
///   Android 上通常使用 yuv420 (三平面，Y/U/V 分离)
///
/// ========================================================================

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // ========== 相机相关状态 ==========

  /// 相机控制器，camera 插件的核心对象
  /// 类比 iOS: AVCaptureSession + AVCaptureVideoPreviewLayer
  CameraController? _controller;

  /// 标识相机是否已成功初始化
  bool _isInitialized = false;

  /// 出错时的错误信息
  String? _errorMessage;

  // ========== 图像流相关状态 ==========

  /// 标识当前是否正在接收图像流 (startImageStream 是否已调用)
  bool _isStreaming = false;

  /// 帧计数器：记录从 startImageStream 开始已接收的帧数
  /// 用于在 UI 上展示图像流的工作状态
  int _frameCount = 0;

  /// 最近一帧的基本信息（用于 UI 展示）
  String _lastFrameInfo = '暂无帧数据';

  /// 帧率控制：上一次实际处理帧的时间戳
  /// 在实际项目中，不需要每帧都送去解码，通常 5~10 帧/秒就够了
  DateTime? _lastProcessTime;

  // ========== 动画相关 ==========

  /// 扫描线动画控制器
  late AnimationController _animationController;

  /// 扫描线位置动画 (0.0 → 1.0 表示从顶部到底部)
  late Animation<double> _scanLineAnimation;

  // ========== 扫描结果 ==========

  /// 扫描到的二维码结果列表
  final List<String> _scanResults = [];

  // =================================================================
  // 生命周期方法
  // =================================================================

  @override
  void initState() {
    super.initState();

    // 注册生命周期观察者，用于处理 App 前后台切换
    WidgetsBinding.instance.addObserver(this);

    // 初始化扫描线动画
    // 使用 repeat(reverse: true) 让扫描线在扫描框内上下往复移动
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 一次完整移动耗时 2 秒
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // 缓入缓出，更自然
      ),
    );

    // 初始化相机
    _initCamera();
  }

  @override
  void dispose() {
    // 移除生命周期观察者
    WidgetsBinding.instance.removeObserver(this);
    // 释放动画控制器
    _animationController.dispose();
    // 先停止图像流，再释放相机
    _stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  /// 监听 App 生命周期变化
  /// 当 App 进入后台时必须释放相机资源，回到前台时重新初始化
  /// 类比 iOS: applicationDidEnterBackground / applicationWillEnterForeground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      // App 即将进入后台 → 停止图像流、释放相机
      _stopImageStream();
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // App 回到前台 → 重新初始化相机
      _initCamera();
    }
  }

  // =================================================================
  // 相机初始化
  // =================================================================

  /// 初始化相机
  /// 扫码场景对分辨率要求不高，使用 medium (480p) 即可
  /// 较低的分辨率 = 更小的帧数据 = 更快的解码速度
  Future<void> _initCamera() async {
    try {
      // 获取设备上所有可用的相机
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = '未找到可用的相机设备');
        return;
      }

      // 创建 CameraController
      _controller = CameraController(
        cameras.first, // 默认使用后置摄像头
        ResolutionPreset.medium, // 扫码用 480p 即可，兼顾速度与识别率
        enableAudio: false, // 扫码不需要麦克风
        /// imageFormatGroup 指定图像帧的像素格式：
        ///   - bgra8888: 单平面，每像素 4 字节 (B/G/R/A)，iOS 推荐
        ///   - yuv420:   三平面 (Y/U/V 分离)，Android 常用
        ///   - nv21:     Android 旧格式
        ///
        /// 选择哪种格式取决于你的解码库支持什么格式
        /// iOS 上 bgra8888 处理最简单；Android 上 yuv420 最通用
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );

      // 初始化控制器（异步操作，可能耗时数百毫秒）
      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      setState(() => _errorMessage = '相机初始化失败: $e');
    }
  }

  // =================================================================
  // 核心功能: startImageStream / stopImageStream
  // =================================================================

  /// ★ 启动图像流 —— 这是实现自定义扫码的核心 API
  ///
  /// 调用 startImageStream 后，camera 插件会在每一帧到达时
  /// 触发回调函数，传入一个 CameraImage 对象。
  ///
  /// 你可以在回调中：
  ///   1. 提取 CameraImage 的像素数据 (image.planes[0].bytes)
  ///   2. 将数据通过 MethodChannel 发送给原生端进行解码
  ///   3. 或者在 Dart Isolate 中使用纯 Dart 库解码
  ///
  /// 类比 iOS: AVCaptureVideoDataOutputSampleBufferDelegate
  ///           的 captureOutput(_:didOutput:from:) 方法
  ///
  /// 注意事项：
  ///   - 回调会在主线程 (UI 线程) 执行，不要在里面做耗时操作
  ///   - 建议做帧率控制，不必每帧都送去解码
  ///   - startImageStream 和 takePicture 不能同时使用
  Future<void> _startImageStream() async {
    if (_controller == null || _isStreaming) return;

    try {
      await _controller!.startImageStream((CameraImage image) {
        // -------- 帧计数 --------
        _frameCount++;

        // -------- 帧率控制 --------
        // 实际项目中，不需要处理每一帧，通常 100~200ms 处理一次即可
        // 这样既能保证扫码速度，又不会过度消耗 CPU
        final now = DateTime.now();
        if (_lastProcessTime != null &&
            now.difference(_lastProcessTime!).inMilliseconds < 200) {
          return; // 距离上次处理不到 200ms，跳过这一帧
        }
        _lastProcessTime = now;

        // -------- 提取帧信息 (展示用) --------
        final plane = image.planes.first;
        setState(() {
          _lastFrameInfo =
              '尺寸: ${image.width}×${image.height}\n'
              '格式: ${image.format.group.name}\n'
              '平面数: ${image.planes.length}\n'
              '首平面大小: ${plane.bytes.length} bytes\n'
              '每行字节数: ${plane.bytesPerRow}';
        });

        // ============================================
        // ★★★ 在这里添加你的二维码解码逻辑 ★★★
        //
        // 方式 A: 通过 MethodChannel 调用原生解码
        //
        //   /// iOS 端 (Swift):
        //   /// 使用 CIDetector 或 Vision 框架解析 CIImage
        //   ///
        //   /// Android 端 (Kotlin):
        //   /// 使用 ML Kit 的 BarcodeScanning API
        //   /// 或使用 ZXing 库
        //
        //   final result = await MethodChannel('qr_decoder')
        //       .invokeMethod('decode', {
        //     'bytes': plane.bytes,
        //     'width': image.width,
        //     'height': image.height,
        //     'bytesPerRow': plane.bytesPerRow,
        //   });
        //   if (result != null) {
        //     _onQrCodeDetected(result as String);
        //   }
        //
        // 方式 B: 使用 Dart Isolate 在后台线程解码
        //
        //   /// 使用 compute() 或 Isolate.spawn() 避免阻塞 UI
        //   /// 搭配纯 Dart 的二维码解码库
        //
        //   final result = await compute(
        //     decodeQrFromBytes,
        //     QrDecodeParams(
        //       bytes: plane.bytes,
        //       width: image.width,
        //       height: image.height,
        //     ),
        //   );
        //   if (result != null) {
        //     _onQrCodeDetected(result);
        //   }
        //
        // ============================================
      });

      setState(() => _isStreaming = true);
    } catch (e) {
      _showSnackBar('启动图像流失败: $e');
    }
  }

  /// 停止图像流
  /// 在页面离开、App 进入后台、或用户手动暂停时调用
  Future<void> _stopImageStream() async {
    if (_controller == null || !_isStreaming) return;
    try {
      await _controller!.stopImageStream();
      setState(() => _isStreaming = false);
    } catch (e) {
      // 停止时的错误通常可以忽略（比如相机已被释放）
    }
  }

  // =================================================================
  // 扫码结果处理
  // =================================================================

  /// 当识别到二维码时调用
  /// 在实际项目中，这个方法会被 MethodChannel 回调或 Isolate 结果触发
  void _onQrCodeDetected(String value) {
    // 避免重复触发：如果最近刚识别到相同内容，跳过
    if (_scanResults.isNotEmpty && _scanResults.first == value) return;

    // 触觉反馈，让用户知道扫描到了
    HapticFeedback.mediumImpact();

    setState(() {
      _scanResults.insert(0, value); // 最新结果放在列表头部
    });

    // 弹出结果对话框
    _showResultDialog(value);
  }

  /// 模拟扫描结果（由于本教程没有实际接入解码库，用按钮模拟）
  void _simulateScanResult() {
    final mockResults = [
      'https://flutter.dev',
      'https://pub.dev',
      'Hello from QR Code!',
      'flutter_study_demo_v1.0',
      '{"type":"product","id":"12345"}',
    ];
    final result = mockResults[_scanResults.length % mockResults.length];
    _onQrCodeDetected(result);
  }

  // =================================================================
  // UI 弹窗与通知
  // =================================================================

  /// 显示扫描结果对话框
  void _showResultDialog(String value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.qr_code, color: Colors.green),
            SizedBox(width: 8),
            Text('扫描结果'),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          // SelectableText 允许用户长按选择和复制文本
          child: SelectableText(value, style: const TextStyle(fontSize: 15)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              Navigator.pop(context);
              _showSnackBar('已复制到剪贴板');
            },
            child: const Text('复制'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 底部提示条
  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
    }
  }

  // =================================================================
  // UI 构建
  // =================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code 扫码'),
        actions: [
          // 图像流开关按钮
          // 通过切换图标来直观显示当前状态
          IconButton(
            onPressed: _isStreaming ? _stopImageStream : _startImageStream,
            icon: Icon(_isStreaming ? Icons.videocam : Icons.videocam_off),
            tooltip: _isStreaming ? '停止图像流' : '启动图像流',
          ),
        ],
      ),
      body: Column(
        children: [
          // 上方：扫描预览区域（占 3/5 空间）
          Expanded(flex: 3, child: _buildScannerView()),
          // 下方：信息面板（占 2/5 空间）
          Expanded(flex: 2, child: _buildInfoPanel()),
        ],
      ),
    );
  }

  // =================================================================
  // 扫描预览区域
  // =================================================================

  /// 构建扫描预览视图
  /// 包含：相机预览 + 遮罩 + 扫描框 + 扫描线动画 + 状态信息
  Widget _buildScannerView() {
    // 错误状态
    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _initCamera,
                child: const Text('重新初始化'),
              ),
            ],
          ),
        ),
      );
    }

    // 加载状态
    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text('正在初始化相机...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    // 正常状态：叠加多个层来构建扫码界面
    return Stack(
      children: [
        // 第 1 层: 相机实时预览
        // 使用 FittedBox + BoxFit.cover 让画面填满容器（可能会裁剪）
        SizedBox.expand(
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                // 注意: previewSize 的 width/height 需要交换
                // 因为相机传感器的方向和屏幕方向通常是垂直的
                width: _controller!.value.previewSize?.height ?? 300,
                height: _controller!.value.previewSize?.width ?? 400,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
        ),

        // 第 2 层: 半透明遮罩 + 扫描框
        // 将扫描框以外的区域盖上半透明黑色，突出扫描区域
        _buildScanOverlay(),

        // 第 3 层: 扫描线动画
        // 一条绿色渐变线在扫描框内上下移动
        _buildScanLine(),

        // 第 4 层: 顶部状态信息
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isStreaming ? '图像流运行中 · 已接收 $_frameCount 帧' : '点击右上角按钮启动图像流',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),

        // 第 5 层: 模拟扫描按钮
        // 由于本教程未接入实际解码库，通过此按钮模拟扫描到结果的流程
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: _simulateScanResult,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('模拟扫描结果'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =================================================================
  // 扫描遮罩层
  // =================================================================

  /// 构建扫描框遮罩
  ///
  /// 原理：在相机预览上方叠加四个半透明矩形，
  ///       围出一个正方形的透明区域作为扫描框。
  ///
  ///   ┌─────────────────────┐
  ///   │   半透明遮罩 (上)    │
  ///   ├────┬──────────┬─────┤
  ///   │遮罩│ 扫描框    │遮罩 │
  ///   │(左)│ (透明)    │(右) │
  ///   ├────┴──────────┴─────┤
  ///   │   半透明遮罩 (下)    │
  ///   └─────────────────────┘
  Widget _buildScanOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 扫描框大小（正方形边长）
        const scanSize = 220.0;
        // 计算扫描框的居中位置
        final left = (constraints.maxWidth - scanSize) / 2;
        final top = (constraints.maxHeight - scanSize) / 2;

        return Stack(
          children: [
            // 上方遮罩
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: top,
              child: Container(color: Colors.black38),
            ),
            // 下方遮罩
            Positioned(
              top: top + scanSize,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.black38),
            ),
            // 左侧遮罩
            Positioned(
              top: top,
              left: 0,
              width: left,
              height: scanSize,
              child: Container(color: Colors.black38),
            ),
            // 右侧遮罩
            Positioned(
              top: top,
              right: 0,
              width: left,
              height: scanSize,
              child: Container(color: Colors.black38),
            ),
            // 扫描框四角装饰线
            Positioned(
              left: left,
              top: top,
              child: _buildCornerDecoration(scanSize),
            ),
          ],
        );
      },
    );
  }

  /// 扫描框四角装饰
  ///
  /// 在扫描框的四个角各画两条短线（一横一竖），
  /// 形成 L 形装饰，让扫描框更醒目。
  ///
  /// 实现方式: 使用 Stack + Positioned + Container 定位 8 条线
  Widget _buildCornerDecoration(double size) {
    const color = Colors.greenAccent; // 装饰线颜色
    const len = 24.0; // 装饰线长度
    const width = 3.0; // 装饰线粗细

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // ---- 左上角 ----
          Positioned(
            left: 0,
            top: 0,
            child: Container(width: len, height: width, color: color),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(width: width, height: len, color: color),
          ),
          // ---- 右上角 ----
          Positioned(
            right: 0,
            top: 0,
            child: Container(width: len, height: width, color: color),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(width: width, height: len, color: color),
          ),
          // ---- 左下角 ----
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(width: len, height: width, color: color),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(width: width, height: len, color: color),
          ),
          // ---- 右下角 ----
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(width: len, height: width, color: color),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(width: width, height: len, color: color),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // 扫描线动画
  // =================================================================

  /// 构建扫描线
  ///
  /// 扫描线是一条水平的渐变线条，在扫描框内上下移动。
  /// 使用 AnimatedBuilder 监听 _scanLineAnimation 的值来定位。
  ///
  /// 渐变效果: 两端透明，中间亮绿色，看起来像光束
  Widget _buildScanLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const scanSize = 220.0;
        final left = (constraints.maxWidth - scanSize) / 2;
        final top = (constraints.maxHeight - scanSize) / 2;

        return AnimatedBuilder(
          animation: _scanLineAnimation,
          builder: (context, child) {
            return Positioned(
              left: left + 4,
              // 扫描线的 Y 坐标 = 扫描框顶部 + 动画值 * 扫描框高度
              top: top + (_scanLineAnimation.value * (scanSize - 4)),
              child: Container(
                width: scanSize - 8,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.withOpacity(0), // 左端透明
                      Colors.greenAccent, // 中间亮绿
                      Colors.greenAccent.withOpacity(0), // 右端透明
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =================================================================
  // 底部信息面板
  // =================================================================

  /// 底部信息面板
  /// 使用 TabBar 切换「扫描记录」和「帧数据 & 原理」两个标签页
  Widget _buildInfoPanel() {
    return Container(
      color: Colors.grey.shade100,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '扫描记录'),
                Tab(text: '帧数据 & 原理'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildHistoryTab(), _buildPrincipleTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 扫描记录标签页
  /// 展示所有扫描到的二维码内容，支持点击复制
  Widget _buildHistoryTab() {
    if (_scanResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('暂无扫描记录', style: TextStyle(color: Colors.grey)),
            Text(
              '启动图像流后将自动扫描',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.qr_code, color: Colors.green),
            title: Text(
              _scanResults[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _scanResults[index]));
                _showSnackBar('已复制');
              },
            ),
          ),
        );
      },
    );
  }

  /// 帧数据 & 原理标签页
  /// 实时展示图像帧信息，并说明解码流程
  Widget _buildPrincipleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 实时帧信息展示
          _codeBlock('📷 最近一帧信息', _lastFrameInfo),
          const SizedBox(height: 12),

          // startImageStream 核心 API 说明
          _codeBlock(
            '★ 核心 API: startImageStream',
            'controller.startImageStream(\n'
                '  (CameraImage image) {\n'
                '    // image.planes[0].bytes → 像素数据\n'
                '    // image.width / height  → 尺寸\n'
                '    // 将数据交给原生端或 Isolate 解码\n'
                '  },\n'
                ');',
          ),
          const SizedBox(height: 8),

          // MethodChannel 桥接解码说明
          _codeBlock(
            '★ MethodChannel 调用原生解码',
            '// Dart 端发送帧数据:\n'
                'final result = await MethodChannel("qr_decoder")\n'
                '    .invokeMethod("decode", {\n'
                '  "bytes": plane.bytes,\n'
                '  "width": image.width,\n'
                '  "height": image.height,\n'
                '});\n'
                '\n'
                '// iOS 原生端 (Swift):\n'
                '// 使用 CIDetector 或 Vision 框架\n'
                '\n'
                '// Android 原生端 (Kotlin):\n'
                '// 使用 ML Kit 或 ZXing',
          ),
          const SizedBox(height: 8),

          // 帧率控制说明
          _codeBlock(
            '★ 帧率控制（性能优化）',
            '// 不需要处理每一帧，200ms 处理一次即可\n'
                'final now = DateTime.now();\n'
                'if (now.difference(lastTime).inMilliseconds < 200) {\n'
                '  return; // 跳过这一帧\n'
                '}\n'
                'lastTime = now;',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // =================================================================
  // 辅助 UI 组件
  // =================================================================

  /// 代码块展示组件
  /// 用于在「原理」标签页中展示代码片段
  Widget _codeBlock(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            code,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
