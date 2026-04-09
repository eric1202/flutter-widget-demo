import '../models/component_detail.dart';

const Map<String, ComponentDetail> aData = {
  'AlertDialog': ComponentDetail(
    name: 'AlertDialog',
    introduction: '弹出式对话框，常用于确认操作、显示警告信息。',
    code: '''showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('确认删除'),
    content: Text('此操作不可撤销，确定要删除吗？'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('取消')),
      ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text('确认')),
    ],
  ),
);''',
    parameters: [
      'title：对话框标题（Widget）',
      'content：对话框内容（Widget）',
      'actions：操作按钮列表',
      'backgroundColor：背景颜色',
      'shape：形状（圆角等）'
    ],
    notes: [
      '必须配合 showDialog 使用',
      '点击外部区域默认不会关闭，需设置 barrierDismissible: true',
      '不要在 actions 中使用 PopScope 拦截返回键'
    ],
  ),
  'Align': ComponentDetail(
    name: 'Align',
    introduction: '控制子组件在父容器中的对齐方式。',
    code: '''Align(
  alignment: Alignment.bottomRight,
  child: Icon(Icons.star, size: 48),
)''',
    parameters: [
      'alignment：对齐方式（Alignment 类型）',
      'widthFactor / heightFactor：宽高因子，不指定则撑满父容器'
    ],
    notes: [
      'Align 会根据子组件自身尺寸来定位，而不是像 Center 那样强制居中',
      '常用 alignment: Alignment.center 等同于 Center'
    ],
  ),
  'AnimatedAlign': ComponentDetail(
    name: 'AnimatedAlign',
    introduction: 'Align 的动画版本，支持对齐方式的平滑过渡。',
    code: '''AnimatedAlign(
  alignment: _isExpanded ? Alignment.bottomRight : Alignment.topLeft,
  duration: Duration(milliseconds: 300),
  child: Icon(Icons.star),
)''',
    parameters: [
      'alignment：目标对齐方式',
      'duration：动画时长',
      'curve：动画曲线（默认 Curves.linear）'
    ],
    notes: [
      '适用于 UI 状态切换的对齐动画',
      '性能优于手动用 TweenAnimationBuilder 实现'
    ],
  ),
  'AnimatedBuilder': ComponentDetail(
    name: 'AnimatedBuilder',
    introduction: '通用的动画构建器，用于封装动画逻辑。',
    code: '''AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value * 2 * pi,
      child: child,
    );
  },
  child: Icon(Icons.refresh),
)''',
    parameters: [
      'animation：监听的通知器（Listenable，如 AnimationController）',
      'builder：构建函数，接收 context 和 child',
      'child：不变的子组件（用于优化重建）'
    ],
    notes: [
      'child 应放在 builder 外部，避免不必要的重建',
      'AnimatedBuilder 是性能优化的动画封装方式'
    ],
  ),
  'AnimatedContainer': ComponentDetail(
    name: 'AnimatedContainer',
    introduction: '带动画效果的 Container，属性变化时自动触发动画。',
    code: '''AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 200 : 100,
  decoration: BoxDecoration(
    color: _isExpanded ? Colors.blue : Colors.red,
    borderRadius: BorderRadius.circular(20),
  ),
)''',
    parameters: [
      'duration / curve：动画时长 and 曲线',
      '所有 Container 的样式参数均可渐变动画（width、height、color、padding、margin、decoration 等）'
    ],
    notes: [
      '只有支持插值的属性才能动画',
      '适用于状态切换的平滑过渡效果'
    ],
  ),
  'AnimatedCrossFade': ComponentDetail(
    name: 'AnimatedCrossFade',
    introduction: '两个子组件之间的交叉渐变，常用于切换显示不同内容。',
    code: '''AnimatedCrossFade(
  duration: Duration(milliseconds: 300),
  crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  firstChild: Icon(Icons.favorite, size: 100),
  secondChild: Icon(Icons.favorite_border, size: 50),
)''',
    parameters: [
      'crossFadeState：切换状态（CrossFadeState.showFirst / showSecond）',
      'firstChild / secondChild：两个子组件',
      'duration：动画时长'
    ],
    notes: [
      '不能传 null 给 firstChild 或 secondChild，可用 SizedBox 占位'
    ],
  ),
  'AnimatedOpacity': ComponentDetail(
    name: 'AnimatedOpacity',
    introduction: '控制透明度的动画组件。',
    code: '''AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: Text('渐变显示'),
)''',
    parameters: [
      'opacity：透明度值（0.0 ~ 1.0）',
      'duration：动画时长',
      'curve：动画曲线'
    ],
    notes: [
      '设为 0 时仍然占据布局空间，若想完全隐藏并释放空间，用 Visibility 替代'
    ],
  ),
  'AnimatedPadding': ComponentDetail(
    name: 'AnimatedPadding',
    introduction: '内边距的动画版本。',
    code: '''AnimatedPadding(
  padding: EdgeInsets.all(_isExpanded ? 32.0 : 8.0),
  duration: Duration(milliseconds: 300),
  child: Text('内容'),
)''',
    notes: [
      '适用于布局间距变化的动画'
    ],
  ),
  'AnimatedPositioned': ComponentDetail(
    name: 'AnimatedPositioned',
    introduction: 'Stack 中子组件位置的动画版本。',
    code: '''AnimatedPositioned(
  duration: Duration(milliseconds: 400),
  left: _isMoved ? 100 : 0,
  top: _isMoved ? 100 : 0,
  child: Container(width: 50, height: 50, color: Colors.blue),
)''',
    notes: [
      '仅在 Stack 内使用',
      '不支持 right 和 bottom 同时设置，会冲突'
    ],
  ),
  'AnimatedSize': ComponentDetail(
    name: 'AnimatedSize',
    introduction: '子组件尺寸变化时的自动动画。',
    code: '''AnimatedSize(
  duration: Duration(milliseconds: 300),
  child: _showLarge ? Container(width: 200, height: 200, color: Colors.red) : Container(width: 50, height: 50),
)''',
  ),
  'AspectRatio': ComponentDetail(
    name: 'AspectRatio',
    introduction: '强制子组件保持特定宽高比。',
    code: '''AspectRatio(
  aspectRatio: 16 / 9,
  child: Image.network('https://example.com/image.jpg', fit: BoxFit.cover),
)''',
    parameters: [
      'aspectRatio：宽高比（宽度 / 高度）'
    ],
    notes: [
      '父容器必须提供有限约束（不能无限宽高）',
      '常见比例：16/9（视频）、4/3（图片）、1/1（方形）'
    ],
  ),
  'AppBar': ComponentDetail(
    name: 'AppBar',
    introduction: 'Scaffold 的顶部应用栏，提供标题、导航、操作按钮。',
    code: '''Scaffold(
  appBar: AppBar(
    title: Text('我的应用'),
    leading: Icon(Icons.arrow_back),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
      IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
    ],
    backgroundColor: Colors.blue,
    elevation: 4,
  ),
)''',
    parameters: [
      'title：标题',
      'leading / actions：左侧和右侧操作区',
      'backgroundColor / elevation：背景色和阴影',
      'bottom：底部组件（如 TabBar）'
    ],
    notes: [
      'AppBar 会自动添加状态栏高度的安全区域',
      '在 iOS 上默认有刘海适配'
    ],
  ),
};
