import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// ========================================================================
/// BasicCameraPage - 基础相机调用教程
/// ========================================================================
///
/// 本页面演示了 Flutter 中使用相机的最基本流程：
///
/// 【核心知识点】
///
/// 1. availableCameras()
///    - 获取设备上所有可用的相机列表
///    - 返回 List<CameraDescription>，每个描述包含：
///      · name: 相机名称
///      · lensDirection: 镜头方向 (front/back/external)
///      · sensorOrientation: 传感器方向
///
/// 2. CameraController
///    - 相机的核心控制器，相当于 iOS 的 AVCaptureSession
///    - 构造参数：
///      · CameraDescription: 要使用哪个相机
///      · ResolutionPreset: 分辨率预设 (low/medium/high/veryHigh/ultraHigh/max)
///    - 必须调用 initialize() 后才能使用
///    - 必须在 dispose() 中释放资源
///
/// 3. CameraPreview
///    - 显示相机实时预览画面的 Widget
///    - 使用方式: CameraPreview(controller)
///
/// 【生命周期管理】
///   - 使用 WidgetsBindingObserver 监听 App 生命周期
///   - 当 App 进入后台时暂停相机（inactive → dispose）
///   - 当 App 回到前台时恢复相机（resumed → initialize）
///   - 这是避免内存泄漏和资源冲突的关键步骤
/// ========================================================================

class BasicCameraPage extends StatefulWidget {
  const BasicCameraPage({super.key});

  @override
  State<BasicCameraPage> createState() => _BasicCameraPageState();
}

/// WidgetsBindingObserver 用于监听应用生命周期变化
/// 类比 iOS: AppDelegate 的 applicationDidEnterBackground 等方法
class _BasicCameraPageState extends State<BasicCameraPage>
    with WidgetsBindingObserver {
  // 相机控制器，核心对象
  CameraController? _controller;

  // 设备上所有可用的相机列表
  List<CameraDescription> _cameras = [];

  // 是否已初始化
  bool _isInitialized = false;

  // 错误信息
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 注册生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    // 初始化相机
    _initCamera();
  }

  @override
  void dispose() {
    // 移除生命周期观察者，防止内存泄漏
    WidgetsBinding.instance.removeObserver(this);
    // 释放相机资源，类比 iOS 中释放 AVCaptureSession
    _controller?.dispose();
    super.dispose();
  }

  /// 监听应用生命周期变化
  /// 类比 iOS: AppDelegate 的各种回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 如果控制器不存在或未初始化，直接返回
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      // App 进入非活跃状态（比如切到后台），释放相机
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // App 回到前台，重新初始化相机
      _initCamera();
    }
  }

  /// 初始化相机
  /// 这是使用 camera 插件的标准流程
  Future<void> _initCamera() async {
    try {
      // 步骤1: 获取所有可用相机
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = '未找到可用的相机设备';
        });
        return;
      }

      // 步骤2: 创建 CameraController
      // 默认使用第一个相机（通常是后置摄像头）
      // ResolutionPreset 可选值:
      //   - low: 240p
      //   - medium: 480p
      //   - high: 720p
      //   - veryHigh: 1080p
      //   - ultraHigh: 2160p (4K)
      //   - max: 设备支持的最高分辨率
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        // enableAudio: false 表示不使用麦克风（仅拍照时建议关闭）
        enableAudio: false,
      );

      // 步骤3: 初始化控制器（异步操作）
      await _controller!.initialize();

      // 步骤4: 更新状态，触发 UI 重建
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } on CameraException catch (e) {
      // CameraException 是 camera 插件定义的异常类型
      setState(() {
        _errorMessage = '相机初始化失败: ${e.description}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = '发生未知错误: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('基础相机调用')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- 相机预览区域 ----
            _buildCameraPreview(),
            const SizedBox(height: 16),

            // ---- 知识点说明 ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('📌 核心步骤'),
                  _codeNote(
                    '1. 获取相机列表',
                    'final cameras = await availableCameras();',
                  ),
                  _codeNote(
                    '2. 创建控制器',
                    'controller = CameraController(\n'
                        '  cameras.first,\n'
                        '  ResolutionPreset.high,\n'
                        ');',
                  ),
                  _codeNote('3. 初始化', 'await controller.initialize();'),
                  _codeNote('4. 显示预览', 'CameraPreview(controller)'),
                  _codeNote('5. 释放资源', 'controller.dispose();'),

                  _sectionTitle('📌 相机信息'),
                  // 显示当前设备的相机信息
                  if (_cameras.isNotEmpty)
                    ..._cameras.asMap().entries.map(
                      (entry) => _infoCard(
                        '相机 ${entry.key}',
                        '名称: ${entry.value.name}\n'
                            '方向: ${entry.value.lensDirection.name}\n'
                            '传感器方向: ${entry.value.sensorOrientation}°',
                      ),
                    ),

                  _sectionTitle('📌 ResolutionPreset 分辨率对照'),
                  _infoCard(
                    '分辨率预设值',
                    'low       → 240p  (省电模式)\n'
                        'medium    → 480p  (标清)\n'
                        'high      → 720p  (高清，推荐)\n'
                        'veryHigh  → 1080p (全高清)\n'
                        'ultraHigh → 2160p (4K)\n'
                        'max       → 设备最高分辨率',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建相机预览区域
  Widget _buildCameraPreview() {
    // 如果有错误信息，显示错误
    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        height: 300,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _initCamera, child: const Text('重试')),
            ],
          ),
        ),
      );
    }

    // 如果未初始化完成，显示加载指示器
    if (!_isInitialized || _controller == null) {
      return Container(
        width: double.infinity,
        height: 300,
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('正在初始化相机...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    // 相机已初始化，显示预览画面
    // CameraPreview 是 camera 插件提供的预览 Widget
    return Container(
      width: double.infinity,
      height: 350,
      color: Colors.black,
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize?.height ?? 300,
            height: _controller!.value.previewSize?.width ?? 400,
            // CameraPreview 是最核心的预览组件
            // 它接收一个 CameraController 参数来显示相机画面
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }

  // ==== 辅助 UI 组件 ====

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _codeNote(String label, String code) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
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
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
