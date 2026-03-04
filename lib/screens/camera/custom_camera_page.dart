import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// ========================================================================
/// CustomCameraPage - 自定义相机操作教程
/// ========================================================================
///
/// 本页面演示了 Flutter 中相机的高级操作功能：
///
/// 【核心知识点】
///
/// 1. 闪光灯控制 (FlashMode)
///    - FlashMode.off: 关闭闪光灯
///    - FlashMode.auto: 自动闪光（根据环境光线）
///    - FlashMode.always: 始终开启闪光
///    - FlashMode.torch: 手电筒模式（持续照明）
///    - 使用方式: controller.setFlashMode(FlashMode.auto)
///    - 类比 iOS: AVCaptureDevice.flashMode / torchMode
///
/// 2. 前后摄像头切换
///    - 通过重新创建 CameraController 并传入不同的 CameraDescription 来实现
///    - cameras[0] 通常是后置相机，cameras[1] 通常是前置相机
///    - 类比 iOS: AVCaptureDeviceInput 切换 device
///
/// 3. 缩放 (Zoom)
///    - controller.getMinZoomLevel() / getMaxZoomLevel() 获取缩放范围
///    - controller.setZoomLevel(value) 设置缩放级别
///    - 可配合 GestureDetector 的 onScaleUpdate 实现手势缩放
///    - 类比 iOS: AVCaptureDevice.videoZoomFactor
///
/// 4. 对焦 (Focus)
///    - controller.setFocusPoint(Offset) 设置对焦点
///    - Offset 值范围 (0,0) 到 (1,1)，代表预览区域的相对位置
///    - controller.setFocusMode(FocusMode.auto) 设置对焦模式
///    - 类比 iOS: AVCaptureDevice.focusPointOfInterest
/// ========================================================================

class CustomCameraPage extends StatefulWidget {
  const CustomCameraPage({super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  String? _errorMessage;

  // 当前使用的相机索引 (0=后置, 1=前置)
  int _currentCameraIndex = 0;

  // 当前闪光灯模式
  FlashMode _currentFlashMode = FlashMode.off;

  // 缩放相关
  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  // 对焦动画的位置
  Offset? _focusPoint;
  bool _showFocusCircle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMessage = '未找到可用的相机设备');
        return;
      }
      await _setupCamera(_cameras[_currentCameraIndex]);
    } catch (e) {
      setState(() => _errorMessage = '相机初始化失败: $e');
    }
  }

  /// 设置/切换相机
  /// 每次切换都需要：释放旧控制器 → 创建新控制器 → 初始化 → 获取缩放范围
  Future<void> _setupCamera(CameraDescription camera) async {
    // 先释放旧的控制器
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    // 获取缩放范围，用于 Slider 的 min/max
    _minZoom = await _controller!.getMinZoomLevel();
    _maxZoom = await _controller!.getMaxZoomLevel();
    _currentZoom = _minZoom;

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  // ==============================================================
  // 功能1: 闪光灯切换
  // ==============================================================
  /// 循环切换闪光灯模式: off → auto → always → torch → off
  Future<void> _toggleFlashMode() async {
    if (_controller == null) return;

    // 定义切换顺序
    final modes = [
      FlashMode.off,
      FlashMode.auto,
      FlashMode.always,
      FlashMode.torch,
    ];

    final currentIndex = modes.indexOf(_currentFlashMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];

    try {
      // 关键 API: setFlashMode
      await _controller!.setFlashMode(nextMode);
      setState(() => _currentFlashMode = nextMode);
    } catch (e) {
      _showSnackBar('闪光灯设置失败: $e');
    }
  }

  // ==============================================================
  // 功能2: 前后摄像头切换
  // ==============================================================
  Future<void> _switchCamera() async {
    if (_cameras.length < 2) {
      _showSnackBar('设备只有一个摄像头');
      return;
    }

    setState(() => _isInitialized = false);

    // 切换索引
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    // 重新设置相机（需要重新创建 Controller）
    await _setupCamera(_cameras[_currentCameraIndex]);
  }

  // ==============================================================
  // 功能3: 缩放控制
  // ==============================================================
  Future<void> _setZoom(double value) async {
    if (_controller == null) return;
    try {
      // 关键 API: setZoomLevel
      await _controller!.setZoomLevel(value);
      setState(() => _currentZoom = value);
    } catch (e) {
      _showSnackBar('缩放设置失败: $e');
    }
  }

  // ==============================================================
  // 功能4: 点击对焦
  // ==============================================================
  /// 通过点击预览区域来设置对焦点
  Future<void> _onTapToFocus(
    TapDownDetails details,
    BoxConstraints constraints,
  ) async {
    if (_controller == null) return;

    // 计算点击位置相对于预览区域的归一化坐标 (0~1)
    final x = details.localPosition.dx / constraints.maxWidth;
    final y = details.localPosition.dy / constraints.maxHeight;

    try {
      // 关键 API: setFocusPoint 和 setFocusMode
      // Offset 的值范围是 (0,0) 到 (1,1)
      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setFocusMode(FocusMode.auto);

      // 显示对焦动画
      setState(() {
        _focusPoint = details.localPosition;
        _showFocusCircle = true;
      });

      // 1秒后隐藏对焦圈
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _showFocusCircle = false);
      }
    } catch (e) {
      _showSnackBar('对焦设置失败: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自定义相机操作')),
      body: Column(
        children: [
          // 相机预览区域（支持点击对焦和手势缩放）
          Expanded(flex: 3, child: _buildPreviewWithGestures()),
          // 控制面板
          Expanded(flex: 2, child: _buildControlPanel()),
        ],
      ),
    );
  }

  /// 构建带手势的预览区域
  Widget _buildPreviewWithGestures() {
    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          // 点击对焦
          onTapDown: (details) => _onTapToFocus(details, constraints),
          // 手势缩放
          onScaleUpdate: (details) {
            // details.scale 是捏合手势的缩放比例
            double newZoom = (_currentZoom * details.scale).clamp(
              _minZoom,
              _maxZoom,
            );
            _setZoom(newZoom);
          },
          child: Stack(
            children: [
              // 相机预览
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize?.height ?? 300,
                      height: _controller!.value.previewSize?.width ?? 400,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                ),
              ),
              // 对焦动画圈
              if (_showFocusCircle && _focusPoint != null)
                Positioned(
                  left: _focusPoint!.dx - 30,
                  top: _focusPoint!.dy - 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.yellow, width: 2),
                    ),
                  ),
                ),
              // 缩放级别指示
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentZoom.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建控制面板
  Widget _buildControlPanel() {
    return Container(
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- 闪光灯控制 ----
            _controlSection(
              icon: _flashIcon,
              title: '闪光灯: ${_flashModeName}',
              subtitle: 'setFlashMode(FlashMode.${_currentFlashMode.name})',
              action: ElevatedButton.icon(
                onPressed: _toggleFlashMode,
                icon: Icon(_flashIcon),
                label: const Text('切换'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // ---- 前后切换 ----
            _controlSection(
              icon: Icons.flip_camera_ios,
              title: '摄像头: ${_currentCameraIndex == 0 ? "后置" : "前置"}',
              subtitle: '通过重新创建 CameraController 实现切换',
              action: ElevatedButton.icon(
                onPressed: _switchCamera,
                icon: const Icon(Icons.flip_camera_ios),
                label: const Text('切换'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // ---- 缩放控制 ----
            const Text('缩放控制', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'setZoomLevel(${_currentZoom.toStringAsFixed(1)})  '
              '范围: ${_minZoom.toStringAsFixed(1)}x ~ ${_maxZoom.toStringAsFixed(1)}x',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Slider(
              value: _currentZoom,
              min: _minZoom,
              max: _maxZoom,
              // Slider 拖动时实时更新缩放级别
              onChanged: _setZoom,
              label: '${_currentZoom.toStringAsFixed(1)}x',
            ),

            // ---- 操作提示 ----
            Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '💡 点击预览区域可对焦，双指捏合可缩放',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 闪光灯模式名称
  String get _flashModeName {
    switch (_currentFlashMode) {
      case FlashMode.off:
        return '关闭';
      case FlashMode.auto:
        return '自动';
      case FlashMode.always:
        return '始终开启';
      case FlashMode.torch:
        return '手电筒';
    }
  }

  /// 闪光灯图标
  IconData get _flashIcon {
    switch (_currentFlashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }

  /// 控制区域组件
  Widget _controlSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          action,
        ],
      ),
    );
  }
}
