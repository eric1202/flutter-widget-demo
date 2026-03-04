import 'package:flutter/material.dart';
import 'camera/basic_camera_page.dart';
import 'camera/custom_camera_page.dart';
import 'camera/photo_preview_page.dart';
import 'camera/qr_scanner_page.dart';

/// ========================================================================
/// CameraScreen - 相机功能教程集合
/// ========================================================================
///
/// 本页面是相机相关功能的入口页，包含以下教程：
///
/// 1. 基础相机调用 —— 使用 camera 插件初始化和使用系统相机
///    - 类比 iOS: AVCaptureSession + AVCaptureVideoPreviewLayer
///
/// 2. 自定义相机操作 —— 闪光灯控制、前后摄像头切换、缩放、对焦
///    - 类比 iOS: AVCaptureDevice 的各种属性配置
///
/// 3. 自定义预览与拍照结果展示 —— 拍照并预览结果
///    - 类比 iOS: UIImagePickerController 的拍照和回调
///
/// 4. QR Code 扫码 —— 基于 camera 插件的 startImageStream + 自定义解码
///    - 类比 iOS: AVCaptureVideoDataOutput + CIDetector / Vision
///
/// 涉及的第三方插件：
///   - camera: ^0.11.1 —— Flutter 官方相机插件
///   - permission_handler: ^11.3.1 —— 权限管理
///
/// 平台权限配置（已在项目中配置）：
///   iOS:  Info.plist 中添加 NSCameraUsageDescription
///   Android: AndroidManifest.xml 中添加 CAMERA 权限
/// ========================================================================
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera 相机教程')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- 教程概述卡片 ----
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        '相机模块概述',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '本教程集合展示了 Flutter 中使用相机的核心功能。\n'
                    '涵盖了从基础调用到自定义操作，再到二维码扫描的完整流程。\n\n'
                    '核心插件：\n'
                    '• camera — Flutter 官方相机插件（含扫码功能）\n'
                    '• permission_handler — 运行时权限管理',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- 教程 1: 基础相机 ----
          _buildTutorialTile(
            context,
            icon: Icons.camera_alt,
            color: Colors.teal,
            title: '1. 基础相机调用',
            subtitle: '相机初始化、权限申请、实时预览',
            description:
                '学习如何初始化 CameraController，申请相机权限，'
                '以及使用 CameraPreview 显示实时画面。',
            destination: const BasicCameraPage(),
          ),

          // ---- 教程 2: 自定义相机操作 ----
          _buildTutorialTile(
            context,
            icon: Icons.tune,
            color: Colors.deepPurple,
            title: '2. 自定义相机操作',
            subtitle: '闪光灯、前后切换、缩放、对焦',
            description:
                '深入学习相机的高级控制：闪光灯模式切换、'
                '前后摄像头切换、手势缩放和点击对焦。',
            destination: const CustomCameraPage(),
          ),

          // ---- 教程 3: 拍照预览 ----
          _buildTutorialTile(
            context,
            icon: Icons.photo_library,
            color: Colors.orange,
            title: '3. 拍照与预览',
            subtitle: '拍照、预览结果、自定义预览视图',
            description:
                '学习如何拍照（takePicture）并在自定义预览页中展示结果，'
                '包含图片信息显示和分享功能入口。',
            destination: const PhotoPreviewPage(),
          ),

          // ---- 教程 4: QR Code 扫码 ----
          _buildTutorialTile(
            context,
            icon: Icons.qr_code_scanner,
            color: Colors.redAccent,
            title: '4. QR Code 扫码',
            subtitle: '基于 camera 插件的实时扫码',
            description:
                '使用 camera 插件的 startImageStream 获取视频帧，'
                '通过 MethodChannel 桥接原生解码，含扫描动画和结果展示。',
            destination: const QrScannerPage(),
          ),
        ],
      ),
    );
  }

  /// 构建教程入口卡片
  Widget _buildTutorialTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String description,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 左侧图标圆形背景
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                // 右侧标题和描述
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
