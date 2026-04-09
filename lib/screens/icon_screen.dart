import 'package:flutter/material.dart';

class IconScreen extends StatelessWidget {
  const IconScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon (图标) 详解'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 基础图标使用
          const _SectionTitle('1. 基础内置图标 (Icons)'),
          const _Description('Flutter 自带了全套的 Material Design 图标，可通过 Icons 静态访问。'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.home),
              Icon(Icons.favorite),
              Icon(Icons.settings),
              Icon(Icons.person),
            ],
          ),
          const SizedBox(height: 32),

          // 2. 图标的样式控制 (大小、颜色)
          const _SectionTitle('2. 图标的样式控制'),
          const _Description('通过 size 控制大小，通过 color 控制颜色。由于是矢量图标，放大不会失真。'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.star, size: 24, color: Colors.amber),
              Icon(Icons.star, size: 48, color: Colors.amber),
              Icon(Icons.star, size: 72, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 32),

          // 3. IconButton 交互图标
          const _SectionTitle('3. 带交互的图标 (IconButton)'),
          const _Description('如果图标需要被点击，使用 IconButton 可以自带水波纹点击效果。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.volume_up),
                color: Colors.blue,
                iconSize: 40,
                onPressed: () {
                  // 点击事件处理
                },
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up),
                color: Colors.green,
                iconSize: 40,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 4. 不同风格的图标
          const _SectionTitle('4. 变体图标'),
          const _Description('部分图标提供了 outlined(空心)、rounded(圆润)、sharp(尖角) 变体。'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.add_circle, size: 40),
                  Text('默认(实心)', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.add_circle_outline, size: 40),
                  Text('outline(空心)', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          )
        ],
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
