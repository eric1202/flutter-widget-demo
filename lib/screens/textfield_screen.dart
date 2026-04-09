import 'package:flutter/material.dart';

class TextFieldScreen extends StatefulWidget {
  const TextFieldScreen({super.key});

  @override
  State<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  // 定义文本控制器，用于获取输入框的内容或主动修改它
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // 务必在页面销毁时释放控制器，避免内存泄漏
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 点击空白处收起键盘的常用做法：用 GestureDetector 包裹并在 onTap 中取消焦点
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TextField (输入框) 详解'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. 基础输入框
            const _SectionTitle('1. 基础 TextField'),
            const _Description('最简单的文本输入框。'),
            const TextField(),
            const SizedBox(height: 32),

            // 2. 带占位符/装饰的输入框
            const _SectionTitle('2. 输入装饰 (InputDecoration)'),
            const _Description('通过 decoration 配置提示文本、边框、前后图标。'),
            const TextField(
              decoration: InputDecoration(
                hintText: '请输入搜索内容...', // 占位提示文字
                prefixIcon: Icon(Icons.search), // 前置图标
                border: OutlineInputBorder(), // 添加外层边框
              ),
            ),
            const SizedBox(height: 32),

            // 3. 密码框与键盘类型
            const _SectionTitle('3. 密码输入与数字键盘'),
            const _Description('obscureText 隐藏文本内容，keyboardType 指定键盘布局。'),
            const TextField(
              obscureText: true, // 开启密码模式（密文显示）
              keyboardType: TextInputType.number, // 限制只能呼出数字键盘
              decoration: InputDecoration(
                labelText: '支付密码', // 悬浮标签文字
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 32),

            // 4. 数据获取与控制器展示
            const _SectionTitle('4. 控制器获取数据 (Controller)'),
            const _Description('绑定 TextEditingController 即可在其他地方获取输入内容。'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '在这里输入点什么...',
                border: const OutlineInputBorder(),
                // 后置按钮：点击清除内容
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear(); 
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 读取 controller.text 即可获取当前输入的值
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('您输入的内容是：${_controller.text}')),
                );
              },
              child: const Text('获取上方输入框内容'),
            )
          ],
        ),
      ),
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
