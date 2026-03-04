import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// ========================================================================
/// PhotoPreviewPage - 拍照与预览教程
/// ========================================================================
///
/// 本页面演示了完整的拍照流程：
///
/// 【核心知识点】
///
/// 1. 拍照 (takePicture)
///    - controller.takePicture() 返回 XFile 对象
///    - XFile 包含照片的临时路径 (path)、名称 (name)、大小等信息
///    - 拍照是异步操作，需要 await
///    - 类比 iOS: AVCapturePhotoOutput.capturePhoto
///
/// 2. XFile (跨平台文件)
///    - 来自 cross_file 包，是 Flutter 中跨平台的文件抽象
///    - 常用属性/方法:
///      · path: 文件路径
///      · name: 文件名
///      · readAsBytes(): 读取文件字节
///      · length(): 获取文件大小
///    - 类比 iOS: 就像一个封装了 URL 和元数据的文件引用
///
/// 3. 自定义预览视图
///    - 使用 Image.file(File(xFile.path)) 显示拍摄的照片
///    - 可以在预览页添加各种操作（保存、分享、编辑等）
///    - 类比 iOS: UIImagePickerController 的 delegate 回调
///
/// 4. 图片元信息
///    - 通过 XFile 可以获取文件大小、路径等元信息
///    - 可以进一步使用 dart:io 的 File 获取更多信息
/// ========================================================================

class PhotoPreviewPage extends StatefulWidget {
  const PhotoPreviewPage({super.key});

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  // 拍摄的照片
  XFile? _capturedImage;
  // 是否正在拍照中（防止重复触发）
  bool _isTaking = false;
  // 是否处于预览模式
  bool _isPreviewMode = false;

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
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = '未找到可用的相机设备');
        return;
      }
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _errorMessage = '相机初始化失败: $e');
    }
  }

  // ==============================================================
  // 核心功能: 拍照
  // ==============================================================
  Future<void> _takePicture() async {
    if (_controller == null || _isTaking) return;

    setState(() => _isTaking = true);

    try {
      // ★ 核心 API: takePicture()
      // 返回 XFile 对象，包含照片的临时文件路径
      // 照片会保存在系统临时目录中
      final XFile image = await _controller!.takePicture();

      setState(() {
        _capturedImage = image;
        _isPreviewMode = true;
        _isTaking = false;
      });
    } on CameraException catch (e) {
      setState(() => _isTaking = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('拍照失败: ${e.description}')));
      }
    }
  }

  /// 返回拍照模式
  void _backToCamera() {
    setState(() {
      _isPreviewMode = false;
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPreviewMode ? '照片预览' : '拍照与预览'),
        actions: [
          if (_isPreviewMode)
            IconButton(
              onPressed: _backToCamera,
              icon: const Icon(Icons.camera_alt),
              tooltip: '返回拍照',
            ),
        ],
      ),
      body: _isPreviewMode ? _buildPhotoPreview() : _buildCameraView(),
    );
  }

  /// 构建相机拍照视图
  Widget _buildCameraView() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage!),
          ],
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // 相机预览
        Expanded(
          child: Container(
            color: Colors.black,
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
        ),
        // 底部操作栏
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 拍照按钮
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isTaking ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 提示文字
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.only(bottom: 16),
          child: const Text(
            '点击圆形按钮拍照 → takePicture()',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// ================================================================
  /// 构建自定义预览视图
  /// ================================================================
  /// 拍照后展示照片和元信息，这就是"自定义预览视图"的核心
  Widget _buildPhotoPreview() {
    if (_capturedImage == null) {
      return const Center(child: Text('暂无照片'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // ---- 照片预览 ----
          // ★ 使用 Image.file 来显示本地文件图片
          // File 来自 dart:io, 通过 XFile.path 转换
          Container(
            color: Colors.black,
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400),
            child: Image.file(File(_capturedImage!.path), fit: BoxFit.contain),
          ),

          // ---- 操作按钮栏 ----
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.camera_alt, '重新拍照', _backToCamera),
                _actionButton(Icons.share, '分享', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('分享功能需要 share_plus 插件')),
                  );
                }),
              ],
            ),
          ),

          // ---- 照片元信息 ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('📌 XFile 照片信息'),
                _infoTile('文件名', _capturedImage!.name),
                _infoTile('文件路径', _capturedImage!.path),
                FutureBuilder<int>(
                  future: _capturedImage!.length(),
                  builder: (context, snapshot) {
                    final size = snapshot.data ?? 0;
                    final sizeKB = (size / 1024).toStringAsFixed(1);
                    final sizeMB = (size / 1024 / 1024).toStringAsFixed(2);
                    return _infoTile('文件大小', '$sizeKB KB ($sizeMB MB)');
                  },
                ),

                _sectionTitle('📌 代码要点'),
                _codeBlock(
                  '拍照并获取文件',
                  '// 拍照，返回 XFile\n'
                      'final XFile image = await controller.takePicture();\n\n'
                      '// 获取文件路径\n'
                      'print(image.path);\n'
                      'print(image.name);\n\n'
                      '// 显示照片\n'
                      'Image.file(File(image.path))',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==== 辅助组件 ====

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton.filled(onPressed: onTap, icon: Icon(icon), iconSize: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

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

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBlock(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
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
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
