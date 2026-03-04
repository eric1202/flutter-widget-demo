import 'package:flutter/material.dart';
import 'dart:math';

/// ContainerScreen 展示了 Flutter 中最通用的组件 Container 的各种属性。
/// Container 结合了绘制、定位和大小调整的多种功能。
class ContainerScreen extends StatelessWidget {
  const ContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container 详解')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('1. 基础容器 (Alignment, Padding, Margin)'),
            // Container 是最常用的布局组件，类似于 HTML 中的 <div>
            Container(
              color: Colors.blue.withValues(alpha: 0.1), // 容器背景色（带透明度）
              margin: const EdgeInsets.only(bottom: 20), // 容器外部间距
              child: Container(
                width: 200, // 容器宽度
                height: 100, // 容器高度
                margin: const EdgeInsets.all(10), // 外边距：容器相对于外部组件的距离
                padding: const EdgeInsets.all(20), // 内边距：容器边缘与其子组件之间的距离
                alignment: Alignment.bottomRight, // 子组件在容器内的对齐方式（靠右下角）
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // 容器颜色
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ), // 边框设置：颜色和宽度
                ),
                child: const Text(
                  '对齐与边距',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            _sectionTitle('2. 装饰 (BoxDecoration) - 圆角, 阴影, 渐变'),
            // decoration 属性可以极大地改变容器的外观
            Container(
              width: double.infinity, // 宽度占满整行
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20), // 设置圆角半径
                boxShadow: [
                  // 添加阴影效果
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3), // 阴影颜色
                    offset: const Offset(5, 5), // 阴影偏移量 (x, y)
                    blurRadius: 10, // 阴影模糊程度
                  ),
                ],
                gradient: const LinearGradient(
                  // 线性渐变色
                  colors: [Colors.purple, Colors.blue], // 渐变色列表
                  begin: Alignment.topLeft, // 渐变开始位置
                  end: Alignment.bottomRight, // 渐变结束位置
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                '渐变与阴影',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _sectionTitle('3. 约束 (Constraints)'),
            // constraints 决定了容器的大小范围限制
            Container(
              constraints: const BoxConstraints(
                minWidth: 100, // 最小宽度
                maxWidth: 200, // 最大宽度
                minHeight: 50, // 最小高度
                maxHeight: 100, // 最大高度
              ),
              color: Colors.green,
              child: const Text('此容器宽度被限制在100-200之间'),
            ),

            _sectionTitle('4. 矩阵变换 (Transform)'),
            // transform 允许对容器进行旋转、缩放、平移等变换
            Container(
              margin: const EdgeInsets.only(top: 40, left: 40),
              // 使用 Matrix4 进行齐次坐标变换
              transform:
                  Matrix4.rotationZ(pi / 12) // 绕 Z 轴旋转（弧度，15度约等于 pi/12）
                    ..scaleByDouble(1.1, 1.1, 1.0, 1.0), // 整体缩放到 1.1 倍
              decoration: const BoxDecoration(color: Colors.red),
              padding: const EdgeInsets.all(16),
              child: const Text('旋转与缩放', style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 100), // 页面底部留出一些空白，方便滚动查看
          ],
        ),
      ),
    );
  }

  /// 辅助方法：生成章节标题
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
