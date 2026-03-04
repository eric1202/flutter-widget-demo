import 'package:flutter/material.dart';

/// TextScreen 展示了 Flutter 中文本显示的各种方式。
/// Text 组件是 UI 开发中最基础的组件之一。
class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text 详解')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('1. 基础样式 (TextStyle)'),
            // Text 是显示单词和短语的基本组件
            const Text(
              '常规文本示例',
              // style 属性用于定义文本的外观
              style: TextStyle(
                fontSize: 24, // 字体大小
                color: Colors.blue, // 字体颜色
                fontWeight: FontWeight.bold, // 字重（加粗）
                fontStyle: FontStyle.italic, // 字体风格（倾斜）
                letterSpacing: 2.0, // 字母间距
                decoration: TextDecoration.underline, // 装饰线（如下划线）
              ),
            ),

            _sectionTitle('2. 对齐与行高 (TextAlign & height)'),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: const Text(
                '这是一段居中对齐的文本，并且设置了较大的行高。行高（height）是 fontSize 的倍数。',
                textAlign: TextAlign.center, // 文本对齐方式：居中
                // 这里的 height: 2.0 表示行高是字体大小的两倍
                style: TextStyle(height: 2.0),
              ),
            ),

            _sectionTitle('3. 文本截断 (Overflow & maxLines)'),
            // 当文本内容过多时，可以控制其显示行数和截断方式
            const Text(
              '这段文本非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长非常长',
              maxLines: 1, // 最多显示一行
              overflow: TextOverflow.ellipsis, // 超出部分显示省略号 (...)
              style: TextStyle(fontSize: 18),
            ),

            _sectionTitle('4. 富文本 (Text.rich / RichText)'),
            // 如果一段话中需要不同的样式，可以使用 Text.rich 或 RichText
            Text.rich(
              TextSpan(
                text: 'Text.rich 不同样式的组合: ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  // 在 children 中添加不同的 TextSpan 来展示不同样式
                  const TextSpan(
                    text: '红色加粗',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const TextSpan(text: ' | '),
                  TextSpan(
                    text: '带下划线的蓝色',
                    style: TextStyle(
                      color: Colors.blue[800],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' | '),
                  const TextSpan(
                    text: '放大效果',
                    style: TextStyle(fontSize: 28, color: Colors.orange),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: "RichText字符串\n",
                style: TextStyle(fontSize: 18, color: Colors.orange),
                children: <TextSpan>[
                  TextSpan(
                    text: "字符串2",
                    style: TextStyle(fontSize: 28, color: Colors.black12),
                  ),
                  TextSpan(
                    text: "字符串3",
                    style: TextStyle(fontSize: 16, color: Colors.brown),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 辅助方法：生成章节标题样式
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
