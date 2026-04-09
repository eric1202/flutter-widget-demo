import 'package:flutter/material.dart';
import 'screens/container_screen.dart';
import 'screens/text_screen.dart';
import 'screens/button_screen.dart';
import 'screens/layout_screen.dart';
import 'screens/list_screen.dart';
import 'screens/image_screen.dart';
import 'screens/icon_screen.dart';
import 'screens/textfield_screen.dart';
import 'screens/dialog_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/pdf_study_screen.dart';

// 这是flutter项目的入口
void main() {
  runApp(const MyApp());
}

// MyApp 是整个应用的根组件
class MyApp extends StatelessWidget {
  // 构造函数，写法：const 构造函数用于创建不可变对象
  const MyApp({super.key});

  // biuld方法，用于构建UI界面
  @override
  Widget build(BuildContext context) {
    // MaterialApp 是 Flutter 提供的 Material Design 风格的应用程序模板
    // 一般自定义app，都会用到这个组件，也有其他类型的组件，比如CupertinoApp
    return MaterialApp(
      // 应用程序的标题
      title: 'Flutter Core Components Demo',
      // 主题
      theme: ThemeData(
        // 主题颜色
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // 是否使用 Material Design 3
        useMaterial3: true,
        // appbar主题
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      // 首页
      home: const HomePage(),
    );
  }
}

// 首页应该单独文件会更好，这里为了方便就写在一起了
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // build方法，用于构建UI界面
  @override
  Widget build(BuildContext context) {
    // Scaffold 是 Flutter 提供的 Material Design 风格的应用程序模板
    // 一般自定义app，都会用到这个组件，也有其他类型的组件，比如CupertinoApp
    return Scaffold(
      // appbar是导航栏
      appBar: AppBar(title: const Text('Flutter 基础组件调研')),
      // body是页面主体内容
      body: ListView(
        // ListView 是 Flutter 提供的滚动组件
        padding: const EdgeInsets.all(16),
        children: [
          // _buildMenuTile 是一个自定义的组件，用于构建菜单项
          // _下划线是private的标志，表示这个方法只能在当前文件中使用
          _buildMenuTile(
            context,
            icon: Icons.check_box_outline_blank,
            title: 'Container (容器)',
            subtitle: '类比 iOS: UIView + CALayer',
            destination: const ContainerScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.text_fields,
            title: 'Text (文本)',
            subtitle: '类比 iOS: UILabel',
            destination: const TextScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.smart_button,
            title: 'Button (按钮)',
            subtitle: '类比 iOS: UIButton',
            destination: const ButtonScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.layers,
            title: 'Layout (多子布局)',
            subtitle: 'Row, Column, Stack',
            destination: const LayoutScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.list,
            title: 'ListView (列表)',
            subtitle: '类比 iOS: UITableView',
            destination: const ListScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.image,
            title: 'Image (图片)',
            subtitle: '类比 iOS: UIImageView',
            destination: const ImageScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.insert_emoticon,
            title: 'Icon (图标)',
            subtitle: '类比 iOS: SFSymbols',
            destination: const IconScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.input,
            title: 'TextField (输入框)',
            subtitle: '类比 iOS: UITextField',
            destination: const TextFieldScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Dialog (弹窗)',
            subtitle: '类比 iOS: UIAlertController',
            destination: const DialogScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.camera_alt,
            title: 'Camera (相机)',
            subtitle: '类比 iOS: AVCaptureSession',
            destination: const CameraScreen(),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.picture_as_pdf,
            title: 'PDF 组件详解析 (A-Z)',
            subtitle: '基于《Flutter 组件详解.pdf》',
            destination: const PdfStudyScreen(),
          ),
        ],
      ),
    );
  }

  // _buildMenuTile 是一个自定义的组件，用于构建菜单项
  Widget _buildMenuTile(
    BuildContext context, {
    //required表示必须传入
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    // Card是卡片组件，用于展示内容
    return Card(
      // elevation是阴影的大小
      elevation: 2,
      // ListTile是列表项组件，用于展示列表项，可以理解为UIKit 的cell
      child: ListTile(
        // leading是列表项前面的图标
        leading: Icon(icon, color: Colors.blue, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            // MaterialPageRoute是路由组件，用于管理页面跳转
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
