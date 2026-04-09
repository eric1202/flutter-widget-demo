# Flutter 基础组件学习 Demo

这是一个专为 Flutter 初学者设计的学习项目，重点展示了核心组件的使用方法，并配有极尽详细的**中文注释**。

## 学习模块详解

项目包含了以下核心教学页面，旨在帮助开发者快速掌握组件的声明式属性配置：

1. **Container 详解** (`lib/screens/container_screen.dart`)
   - **核心理解**：`Container` 类似于 HTML 中的 `div`，是 Flutter 中最常用的“万能装饰盒”。
   - **深入探索**：
     - 理解内容对齐 (`Alignment`) 如何决定子组件位置。
     - 掌握内边距 (`Padding`) 与外边距 (`Margin`) 的空间布局逻辑。
     - 探索 `BoxDecoration`：实现圆角、阴影、边框及复杂的线性渐变效果。
     - **心得**：虽是万能组件，但在只需单一功能（如仅需边距）时，使用 `Padding` 或 `SizedBox` 性能更优。

2. **Text 详解** (`lib/screens/text_screen.dart`)
   - **核心理解**：`Text` 不仅仅是文字显示，更是排版艺术。
   - **核心要点**：
     - 掌握基本文本样式 (`TextStyle`)：字号、颜色、粗细、字体系列等。
     - 学习文本对齐、行高控制及长文本截断优化（`overflow`）。
     - 进阶使用 `RichText` 或 `Text.rich` 实现一段话中包含多种差异化样式。
   - **心得**：在国际化和多设备适配中，注意文本的 `TextScaler` 影响，确保 UI 不因字体放大而崩溃。

3. **Button 详解** (`lib/screens/button_screen.dart`)
   - **核心理解**：按钮是交互的核心，承载了视觉反馈和业务逻辑。
   - **实践内容**：
     - 对比常用按钮：`ElevatedButton`（凸起）、`TextButton`（平面）、`OutlinedButton`（边框）及图表按钮。
     - 学习按钮的交互状态：响应点击 (`onPressed`)、长按 (`onLongPress`) 及禁用逻辑。
     - 深入自定义 `ButtonStyle`：利用 `WidgetStateProperty` 打造响应式的动态交互外观。
   - **心得**：解耦按钮样式与逻辑，善用 `ThemeData` 统一全局按钮风格。

4. **Layout 多子布局详解** (`lib/screens/layout_screen.dart`)
   - **核心理解**：UI 界面是由多个组件拼接而成的，了解如何控制组件间的相对位置是排版的核心。
   - **核心要点**：
     - `Row` 和 `Column`：基础横向与纵向排列，掌握主轴和交叉轴的对齐控制。
     - `Expanded`：分配剩余空间，防溢出必备。
     - `Stack` 和 `Positioned`：实现层叠排版与绝对定位。
     - `Wrap`：流式自动换行布局。
     - `Spacer`：占据可用空间的“弹簧组件”，推开横向或纵向两边的元素。
     - `Card`：带圆角和阴影的 Material 风格容器（默认不带内边距，需配合 `Padding`）。
     - 综合实战：Row + Column + Expanded 构建防溢出的图文卡片列表项。
   - **心得**：遇到组件超出版面报错（黄黑相间警告条纹）时，通常是外层没有明确的约束。尝试为内容定宽/定高，或者使用 `Expanded` 接管剩余空间，长列表/长页面可以嵌套在 `SingleChildScrollView` 中。

5. **ListView 详解** (`lib/screens/list_screen.dart`)
   - **核心理解**：列表是移动端最常见的高性能数据展示方案。
   - **关键模式**：
     - **基础用法**：适用于静态、短小的数据集合。
     - **Builder 模式**：**核心必学**。掌握基于索引的懒加载机制，轻松应对成千上万条记录。
     - **Separated 模式**：学习利用 `separatorBuilder` 在项之间插入分割线或间距。
   - **心得**：在处理列表时，务必注意 `itemExtent` 或 `prototypeItem` 的优化，以显著提升无限列表的滚动性能。

6. **Image 详解** (`lib/screens/image_screen.dart`)
   - **核心理解**：丰富视觉体验的核心，理解本地/网络图片的加载机制。
   - **核心要点**：
     - 使用 `Image.network` 加载网络图片以及 `Image.asset` 加载本地资产资源。
     - 学习 `BoxFit` 填充模式：cover, contain, fill 的应用场景。
     - 了解圆形图片（如头像）的快速实现方案（如 `ClipOval` 或 `CircleAvatar`）。
   - **心得**：大量网络图片建议配合三方库如 `cached_network_image` 以增加缓存提升体验。

7. **Icon 详解** (`lib/screens/icon_screen.dart`)
   - **核心理解**：灵活可缩放的矢量图形系统。
   - **核心要点**：
     - 使用系统内置 `Icons` 及配置图标大小和颜色的基础方法。
     - 特殊用法如结合 `IconButton` 实现带点击态的交互组件。
   - **心得**：图标本质也是字体（IconFont），支持和 `Text` 类似的无损缩放。

8. **TextField 详解** (`lib/screens/textfield_screen.dart`)
   - **核心理解**：用户输入和表单交互的基础，实现强交互界面的必备组件。
   - **核心要点**：
     - 运用 `InputDecoration` 丰富输入框样式（如提示词 hint、边框、前后缀图标）。
     - 通过 `TextEditingController` 读取与控制输入文本内容。
     - 键盘类型控制（`keyboardType`）和密码框切换（`obscureText`）。
   - **心得**：输入框通常需要关联软键盘，可通过包裹 `GestureDetector` 点击屏幕空白处让输入框失去焦点以收起键盘。

9. **Dialog 详解** (`lib/screens/dialog_screen.dart`)
   - **核心理解**：页面层之上的覆盖层，用于提示、确认及轻量交互。
   - **核心要点**：
     - 学习 `showDialog` 调用标准警示框 `AlertDialog`。
     - 了解底部浮现的半屏弹窗 `showModalBottomSheet`。
     - 使用 `SnackBar` 呈现不打断用户操作的瞬息提示。
   - **心得**：弹窗本质上是开了一个新的局部路由（Route），因此关闭弹窗需要调用 `Navigator.pop(context)`。

10. **Camera 相机功能** (`lib/screens/camera_screen.dart`)
   - **核心理解**：相机是移动端常见的硬件交互场景，Flutter 通过插件方式调用原生能力。
   - **实践内容**：
     - 基础相机预览与拍照功能 (`basic_camera_page.dart`)。
     - 拍照后的照片预览 (`photo_preview_page.dart`)。
     - 自定义相机界面 (`custom_camera_page.dart`)。
     - 二维码扫描功能 (`qr_scanner_page.dart`)。
    - **心得**：相机功能涉及设备权限管理 (`permission_handler`)，是学习 Flutter 与原生平台交互的好起点。

11. **PDF 组件学习 (A-Z)** (`lib/screens/pdf_study_screen.dart`)
    - **核心理解**：基于专业文档分类的学习索引。
    - **核心要点**：
      - 严格按照 A-Z 字母顺序编排的 100+ 核心组件全集。
      - 提供快速搜索功能，可根据组件名即时定位。
      - 配合外部 PDF 文档学习每个组件的参数与避坑指南。
    - **心得**：此模块作为“速查词典”，适合在日常开发中随时翻阅，加深对组件全貌的理解。

## 学习心得与原生对比

在学习 Flutter 的过程中，通过与原生开发（Android/iOS）的对比，可以更深刻地理解其设计哲学。以下是一些核心心得分享，希望能为你的学习路径提供参考：

### Flutter vs 原生开发参考

| 特性          | Flutter                                                                             | 原生开发 (Android/iOS)                                                         |
| :------------ | :---------------------------------------------------------------------------------- | :----------------------------------------------------------------------------- |
| **开发效率**  | **极高**：得益于“热重载”技术，UI 修改几乎可以秒级呈现，大幅缩短调试时间。           | **中等**：每次修改 UI 通常需要重新编译运行，反馈周期较长。                     |
| **UI 一致性** | **完美统一**：使用自绘引擎渲染，在不同机型和系统版本上能保持高度一致的视觉效果。    | **存在差异**：需适配不同平台的原生组件库，处理系统差异的工作量大。             |
| **性能表现**  | **非常流畅**：通过 Skia/Impeller 引擎直接与 GPU 通信，能实现 60/120fps 的丝滑动画。 | **极致性能**：由于直接调用系统底层 API，在处理极端复杂的重负载任务时仍具优势。 |
| **代码复用**  | **单一代码库**：逻辑与 UI 均可 90% 以上复用，大幅降低维护成本。                     | **双倍工作量**：通常需要维护两套甚至多套代码，团队协作成本较高。               |

### 核心学习经验

1. **声明式 UI 思维转化**：原生开发常采用“命令式”（如 `findViewById.setText`），而 Flutter 是根据状态渲染。理解“UI = f(state)”是进阶的关键。
2. **组合优于继承**：在 Flutter 中，几乎一切皆 Widget。学会将复杂 UI 拆解成细小的组件进行组合，会让代码结构异常清晰。
3. **不要惧怕原生**：虽然 Flutter 很强大，但在涉及相机、蓝牙或特定硬件交互时，了解如何编写 `MethodChannel` 调用原生能力依然非常重要。

## 项目结构

```
lib/
├── main.dart                          # 应用入口，主页面导航
└── screens/
    ├── container_screen.dart          # Container 组件详解
    ├── text_screen.dart               # Text 组件详解
    ├── button_screen.dart             # Button 组件详解
    ├── layout_screen.dart             # Layout 多子布局详解
    ├── list_screen.dart               # ListView 组件详解
    ├── image_screen.dart              # Image 组件详解
    ├── icon_screen.dart               # Icon 组件详解
    ├── textfield_screen.dart          # TextField 组件详解
    ├── dialog_screen.dart             # Dialog 弹窗详解
    ├── camera_screen.dart             # 相机功能入口
    └── camera/
        ├── basic_camera_page.dart     # 基础相机
        ├── custom_camera_page.dart    # 自定义相机界面
        ├── photo_preview_page.dart    # 照片预览
        └── qr_scanner_page.dart       # 二维码扫描
    └── pdf_study_screen.dart          # PDF 组件 A-Z 学习索引
```

## 运行环境

- Flutter SDK (推荐最新稳定版)
- Dart SDK ^3.10.7

## 如何使用

```bash
# 1. 克隆项目
git clone <repository-url>

# 2. 安装依赖
flutter pub get

# 3. 运行项目
flutter run
```

在每个页面中直接阅读源码中的中文注释进行学习。


## Web 部署

项目已配置 GitHub Actions，推送到 `main` 分支时会自动部署到 GitHub Pages。

### 访问地址
部署完成后，可通过以下地址访问：
`https://eric1202.github.io/flutter-widget-demo/`

### 如何启用
1. 将代码推送到 GitHub。
2. 进入仓库 **Settings** -> **Pages**。
3. 在 **Build and deployment** -> **Source** 中，选择 **Deploy from a branch**。
4. 选择 `gh-pages` 分支并点击 **Save**（该分支由 GitHub Action 自动创建）。

### 技术细节
- 部署由 `.github/workflows/deploy.yml` 处理。
- 构建时使用 `--base-href /flutter-widget-demo/`。

---

希望这个 Demo 能帮助你快速跨过 Flutter 入门的第一道坎！
