import 'package:flutter/material.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog (弹窗) 详解'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. AlertDialog
          const _SectionTitle('1. 基础对话框 (AlertDialog)'),
          const _Description('标准二次确认对话框，通常包含标题、内容和行动按钮。'),
          ElevatedButton(
            onPressed: () {
              // 使用 showDialog 呼出弹框
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('温馨提示'),
                    content: const Text('您确定要执行此危险操作吗？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // pop() 用于关闭由于导航或 showDialog 生成的最顶层路由
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          // 执行确认逻辑
                        },
                        child: const Text('确认', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('显示 AlertDialog'),
          ),
          const SizedBox(height: 32),

          // 2. SimpleDialog
          const _SectionTitle('2. 简单供选项对话框 (SimpleDialog)'),
          const _Description('适用于提供多个供选项的情况。'),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return SimpleDialog(
                    title: const Text('请选择您的性别'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('👨 男'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('👩 女'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('显示 SimpleDialog'),
          ),
          const SizedBox(height: 32),

          // 3. BottomSheet 底部弹窗
          const _SectionTitle('3. 底部面板 (BottomSheet)'),
          const _Description('现代 App 最常用的半屏弹出菜单风格。'),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  // 给底模态增加圆角
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext ctx) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: 200, // 高度随意定
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('分享到', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildShareIcon(Icons.wechat, '微信', Colors.green),
                            _buildShareIcon(Icons.camera_alt, '朋友圈', Colors.greenAccent),
                            _buildShareIcon(Icons.link, '复制链接', Colors.blue),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text('显示 底部弹窗'),
          ),
          const SizedBox(height: 32),

          // 4. SnackBar 轻提示
          const _SectionTitle('4. 轻量级提示 (SnackBar)'),
          const _Description('在底部短暂浮现的一个小黑条，不阻断用户当前行为。'),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ 操作成功！'),
                  duration: const Duration(seconds: 2), // 显示时长控制
                  action: SnackBarAction(
                    label: '撤销',
                    onPressed: () {
                      // 撤销逻辑
                    },
                  ),
                ),
              );
            },
            child: const Text('显示 SnackBar'),
          ),
        ],
      ),
    );
  }

  // 辅助构建 BottomSheet 内分享图标
  Widget _buildShareIcon(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withAlpha(50),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// 辅助组件：统一的小节标题
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// 辅助组件：统一说明文本
class _Description extends StatelessWidget {
  final String text;
  const _Description(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
