import 'package:flutter/material.dart';

/// ButtonScreen 展示了 Flutter 中常用的按钮组件及其用法。
/// 按钮是用户界面中最重要的交互元素之一。
class ButtonScreen extends StatelessWidget {
  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button 详解'),
        // 这里的 AppBar 是页面的顶部导航栏
      ),
      // SingleChildScrollView 允许当内容超过屏幕高度时进行滚动
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('1. 常见按钮类型'),
            // Wrap 组件可以自动换行，适合展示一组按钮
            Wrap(
              spacing: 10, // 子组件之间的水平间距
              runSpacing: 10, // 行与行之间的垂直间距
              children: [
                // ElevatedButton: 凸起按钮，通常用于主要操作
                ElevatedButton(
                  onPressed: () {
                    // 点击按钮时触发的回调
                  },
                  child: const Text('ElevatedButton'),
                ),
                // TextButton: 文本按钮，通常用于次要操作
                TextButton(
                  onPressed: () {},
                  child: const Text('TextButton'),
                ),
                // OutlinedButton: 带边框的按钮
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('OutlinedButton'),
                ),
                // IconButton: 图标按钮，仅显示图标
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_reaction),
                  tooltip: 'IconButton', // 长按显示的提示文字
                ),
              ],
            ),

            _sectionTitle('2. 禁用状态 (onPressed: null)'),
            // 当 onPressed 为 null 时，按钮会自动变为禁用状态（灰色且不可点击）
            const Row(
              children: [
                ElevatedButton(
                  onPressed: null,
                  child: Text('禁用按钮'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: null,
                  child: Text('禁用按钮'),
                ),
              ],
            ),

            _sectionTitle('3. 交互回调 (onLongPress)'),
            // 除了 onPressed，大部分按钮还支持 onLongPress（长按）
            ElevatedButton(
              onPressed: () {
                // 显示底部的提示条 (SnackBar)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('点击了按钮')),
                );
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('长按了按钮')),
                );
              },
              child: const Text('点击或长按我'),
            ),

            _sectionTitle('4. 自定义样式 (ButtonStyle / styleFrom)'),
            // 使用 styleFrom 可以方便地自定义按钮外观
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // 按钮背景色
                foregroundColor: Colors.white, // 按钮上的文字和图标颜色
                elevation: 10, // 阴影高度，数值越大阴影越明显
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ), // 按钮内边距
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
              ),
              child: const Text('自定义样式按钮'),
            ),

            const SizedBox(height: 20),

            // OutlinedButton 的自定义示例
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ), // 设置边框颜色和宽度
                shape: const StadiumBorder(), // 体育场形状（两端半圆）
              ),
              child: const Text(
                '橙色边框按钮',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 封装一个简单的标题组件，用于区分不同的章节
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
}
