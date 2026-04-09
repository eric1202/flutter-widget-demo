import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image (图像) 详解')),
      // 使用 ListView 支持列表滚动，以展示众多案例
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 基础网络图片演示
          const _SectionTitle('1. 基础网络图片 (Image.network)'),
          const _Description('通过 url 直接加载网络图片，最常用的方式之一。'),
          Center(
            child:
                //下方补充代码块介绍
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://picsum.photos/400/200?random=1',
                        width: 300,
                        height: 150,
                        // fit 是图片的填充适应模式，cover 表示等比例缩放直至覆盖整个容器（多余被裁剪）
                        fit: BoxFit.cover,
                      ),
                      Text('1. 基础网络图片 (Image.network)'),
                      Text(
                        '通过 url 直接加载网络图片，最常用的方式之一。 Image.network(url)',
                        textAlign: TextAlign.center, // 👈 关键：让文本内部居中对齐
                      ),
                    ],
                  ),
                ),
          ),

          // 2. 图片填充模式 (BoxFit)
          const _SectionTitle('2. 图片填充模式 (BoxFit)'),
          const _Description(
            '展示所有 BoxFit（contain, cover, fill, fitWidth, fitHeight, none, scaleDown）的表现形式。',
          ),
          Wrap(
            spacing: 16, // 水平间距
            runSpacing: 16, // 垂直间距
            alignment: WrapAlignment.center,
            children: [
              _buildFitBox('contain\n(等比包含)', BoxFit.contain),
              _buildFitBox('cover\n(等比覆盖)', BoxFit.cover),
              _buildFitBox('fill\n(拉伸铺满)', BoxFit.fill),
              _buildFitBox('fitWidth\n(等宽适应)', BoxFit.fitWidth),
              _buildFitBox('fitHeight\n(等高适应)', BoxFit.fitHeight),
              _buildFitBox('none\n(居中裁剪)', BoxFit.none),
              _buildFitBox('scaleDown\n(缩小居中)', BoxFit.scaleDown),
            ],
          ),
          const SizedBox(height: 32),

          // 3. 圆形图片 (头像等)
          const _SectionTitle('3. 圆形与圆角图片'),
          const _Description('常用于用户头像或是卡片上的封面展示。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 使用 CircleAvatar 快速实现圆形包裹
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/100/100?random=2',
                    ),
                  ),
                  const Text('CircleAvatar()'),
                ],
              ),
              Column(
                children: [
                  // 使用 ClipRRect 实现圆角裁剪
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://picsum.photos/100/100?random=3',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text('ClipRRect()'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 4. 图片错误处理 / 加载状态
          const _SectionTitle('4. 图片加载状态监控'),
          const _Description('在加载中显示progress，也可在加载失败则展示一个备用图标。'),
          Center(
            child: Image.network(
              'https://picsum.photos/960/480?random=4',
              width: 300,
              height: 150,
              fit: BoxFit.cover,
              // loadingBuilder：构建图片加载过程中的过渡动画
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child; // 加载完成
                return Container(
                  width: 300,
                  height: 150,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  ),
                );
              },
              // errorBuilder：处理图片加载失败的回调及展示内容
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 300,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      Text('图片加载失败'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 辅助构建填充模式的小方框
  Widget _buildFitBox(String title, BoxFit fit) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          color: Colors.blue[100],
          // 设置一个边框来明确框的范围
          child: Image.network(
            'https://picsum.photos/200/80?random=9', //故意找一个宽高比极端的图
            fit: fit,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        // 补充说明核心参数的代码块
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'fit: $fit',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace', // 使用等宽字体模仿代码块
              color: Colors.blueGrey[800],
            ),
          ),
        ),
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
