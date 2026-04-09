import '../models/component_detail.dart';

const Map<String, ComponentDetail> hiData = {
  'Hero': ComponentDetail(
    name: 'Hero',
    introduction: '页面间共享元素的转场动画。',
    code: '''// 页面 A
Hero(
  tag: 'hero-avatar',
  child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(url)),
)

// 页面 B（同一 tag）
Hero(
  tag: 'hero-avatar',
  child: CircleAvatar(radius: 100, backgroundImage: NetworkImage(url)),
)''',
    notes: [
      '两边 tag 必须相同',
      '子组件尽可能简单，复杂结构可能导致动画抖动'
    ],
  ),
  'HorizontalDivider': ComponentDetail(
    name: 'HorizontalDivider',
    introduction: '水平分割线（Material 3 中 Divider 的新名称）。',
    code: '''HorizontalDivider(
  thickness: 1,
  color: Colors.grey[300],
  indent: 16,
  endIndent: 16,
)''',
  ),
  'Icon': ComponentDetail(
    name: 'Icon',
    introduction: '展示 Material Icons 图标。',
    code: '''Icon(
  Icons.favorite,
  size: 24,
  color: Colors.red,
)''',
    parameters: [
      'icon：图标数据',
      'size / color：尺寸和颜色'
    ],
  ),
  'IconButton': ComponentDetail(
    name: 'IconButton',
    introduction: '图标形式的按钮。',
    code: '''IconButton(
  onPressed: () => print('点击'),
  icon: Icon(Icons.search),
  tooltip: '搜索',
)''',
  ),
  'Image': ComponentDetail(
    name: 'Image',
    introduction: '展示图片内容。',
    code: '''Image.network(
  'https://example.com/image.jpg',
  width: 200, height: 200,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stack) => Icon(Icons.broken_image),
)''',
    parameters: [
      'fit：BoxFit 枚举，控制填充方式',
      'loadingBuilder / errorBuilder：加载中和错误时构建'
    ],
  ),
  'IndexedStack': ComponentDetail(
    name: 'IndexedStack',
    introduction: '只显示指定索引的子组件，保持其他子组件状态。',
    code: '''IndexedStack(
  index: _selectedIndex,
  children: [
    Page1(), Page2(), Page3(),
  ],
)''',
    notes: [
      '适合配合 BottomNavigationBar 切换页面，保持各页面状态'
    ],
  ),
  'InteractiveViewer': ComponentDetail(
    name: 'InteractiveViewer',
    introduction: '支持缩放、拖拽的交互查看器。',
    code: '''InteractiveViewer(
  minScale: 0.5,
  maxScale: 4.0,
  child: Image.network('https://example.com/large-image.jpg'),
)''',
    notes: [
      '适用于图片、地图、文档等需要缩放查看的场景'
    ],
  ),
};
