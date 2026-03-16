import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout 多子布局组件')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Row 横向排列
            const Text(
              '1. Row (横向排列)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Row 将子组件在一行中排列。非常类似于前端 Flexbox 的 row 模式。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // 主轴(这里是横向)上的对齐方式：均匀分布
                crossAxisAlignment:
                    CrossAxisAlignment.center, // 交叉轴(这里是纵向)上的对齐方式：居中对齐
                children: [
                  Icon(Icons.star, size: 50, color: Colors.blue),
                  Icon(Icons.star, size: 30, color: Colors.red),
                  Icon(Icons.star, size: 50, color: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Column 纵向排列
            const Text(
              '2. Column (纵向排列)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Column 将子组件在一列中排列，也是开发中使用极其频繁的组件。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              width: double.infinity, // 撑满父容器宽度
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center, // 主轴(纵向)居中
                crossAxisAlignment: CrossAxisAlignment.start, // 交叉轴(横向)靠左对齐
                children: [
                  Text(
                    '这是第一行内容',
                    style: TextStyle(backgroundColor: Colors.white),
                  ),
                  SizedBox(height: 4), // 可以在元素中间用 SizedBox 占位
                  Text(
                    '这是第二行内容，长度稍微变长一点',
                    style: TextStyle(backgroundColor: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text('第三行！', style: TextStyle(backgroundColor: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Expanded & Flexible 弹性布局
            const Text(
              '3. Expanded (撑满剩余空间)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Expanded 只能在 Row, Column, Flex 中使用，用于占据该轴上的所有剩余空间。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    '固定',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  // Expanded 会抢占这两个蓝色方块中间所有的横向空间
                  child: Container(
                    height: 50,
                    color: Colors.amber,
                    alignment: Alignment.center,
                    child: const Text('Expanded 接管所有剩余空间'),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    '固定',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Stack 层叠布局
            const Text(
              '4. Stack & Positioned (层叠与定位)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stack 类似于前端绝对定位 (absolute)，可以把组件一层层叠起来。例如做头像右上角的红点，图片上的文字等。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                alignment: Alignment.center, // 没有被 Positioned 包裹的组件，默认会在中心对齐
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ), // 位于最底层
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.red,
                  ), // 覆盖在蓝色上方
                  // 使用 Positioned 进行精确的绝对定位
                  Positioned(
                    right: 20, // 距离右侧 20 像素
                    bottom: 20, // 距离底部 20 像素
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: const Text(
                        'Pos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const Positioned(
                    top: 10, // 距离顶部 10 像素
                    left: 10, // 距离左边 10 像素
                    child: Icon(Icons.star, color: Colors.yellow, size: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Wrap 流式布局
            const Text(
              '5. Wrap (流式布局)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '当 Row 中的子组件过多超出屏幕时，会报黄黑相间的溢出错误。Wrap 可以自动换行。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: Wrap(
                spacing: 16.0, // 主轴(水平)方向间距
                runSpacing: 4.0, // 纵轴(垂直)方向间距
                children: List.generate(10, (index) {
                  return Chip(
                    label: Text('标签 $index'),
                    backgroundColor: Colors.blue.shade100,
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // 6. Spacer 弹簧组件
            const Text(
              '6. Spacer (弹簧组件)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Spacer 也是一个占据剩余空间的组件，常用于短平快地将 Row/Column 中的前后两部分元素推开。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              child: const Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('用户名'),
                  Spacer(), // 把后面的元素推到最后
                  Text('详细信息'),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 7. Card 卡片组件
            const Text(
              '7. Card (卡片组件)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Card 是 Material Design 中非常经典的组件，自带圆角和阴影属性，常用于包裹相对独立的一块内容。通常配合 Padding 使用，因为 Card 默认没有内边距。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4, // 控制阴影大小
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // 自定义圆角大小
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card 标题',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '这是 Card 内部的内容。Card 本身只负责外观（阴影、边框、圆角、底色），不负责排版。排版还是需要借助 Column 或 Row 等布局组件。',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 8. 综合实战：常见图文列表项 (Row + Column + Expanded)
            const Text(
              '8. 综合实战 (图文卡片)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '真实业务中最常见的卡片：左边图片，右边上下两行文字(Row包裹图片和Column，Column被Expanded包裹以防溢出)。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // 顶部对齐
                  children: [
                    // 左侧图片占位
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 右侧内容必须用 Expanded 包裹，否则长文本会导致 Row 溢出屏幕
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '这是一段很长的标题文字，如果不使用 Expanded 包裹它所属的 Column，在小屏幕上就会报 overflow 的错误。',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // 两端对齐
                            children: [
                              Text(
                                '2026-03-16',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '10K',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40), // 底部留白，方便滚动
          ],
        ),
      ),
    );
  }
}
