# Flutter 基础组件学习 Demo

这是一个专为 Flutter 初学者设计的学习项目，重点展示了三大核心组件的使用方法，并配有极尽详细的**中文注释**。

## 学习模块详解

项目包含了以下三个核心教学页面，旨在帮助开发者快速掌握组件的声明式属性配置：

1. **Container 详解** (`lib/screens/container_screen.dart`)
   - 深入理解内容对齐 (`Alignment`)。
   - 掌握内边距 (`Padding`) 与外边距 (`Margin`) 的区别。
   - 探索 `BoxDecoration`：实现圆角、阴影、边框及复杂的线性渐变效果。
   - 学习如何使用 `Matrix4` 进行旋转和缩放变换。

2. **Text 详解** (`lib/screens/text_screen.dart`)
   - 掌握基本文本样式 (`TextStyle`)：字号、颜色、粗细等。
   - 学习文本对齐、行高控制及长文本截断优化。
   - 进阶使用 `RichText` 或 `Text.rich` 实现一段话中包含多种差异化样式。

3. **Button 详解** (`lib/screens/button_screen.dart`)
   - 对比常用按钮：`ElevatedButton`、`TextButton`、`OutlinedButton` 及图表按钮。
   - 学习按钮的交互状态：点击、长按及禁用逻辑。
   - 深入自定义 `ButtonStyle`：打造个性化的按钮外观方案。

4. **ListView 详解** (`lib/screens/list_screen.dart`)
   - **基础用法**：适用于简单、小规模的数据列表。
   - **Builder 模式**：学习高性能的懒加载机制，处理大规模数据流。
   - **Separated 模式**：掌握如何在列表项之间通过 `separatorBuilder` 优雅地添加分割线。
   - **横向滚动**：利用 `scrollDirection` 属性扩展列表的展示维度。

## 运行环境

- Flutter SDK (推荐最新稳定版)
- Dart SDK

## 如何使用

1. 克隆或下载本项目。
2. 运行 `flutter pub get` 安装依赖。 或者直接运行 `flutter run`
3. 运行项目，在每个页面中直接阅读源码中的中文注释进行学习。

---

希望这个 Demo 能帮助你快速跨过 Flutter 入门的第一道坎！
