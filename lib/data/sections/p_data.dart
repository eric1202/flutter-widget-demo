import '../models/component_detail.dart';

const Map<String, ComponentDetail> pData = {
  'Padding': ComponentDetail(
    name: 'Padding',
    introduction: '为子组件添加内边距。',
    code: '''Padding(
  padding: EdgeInsets.all(16),
  child: Text('内容'),
)''',
    parameters: [
      'EdgeInsets.all(16)：四周',
      'EdgeInsets.symmetric(horizontal: 16, vertical: 8)：对称',
      'EdgeInsets.only(left: 16)：单边'
    ],
  ),
  'PageView': ComponentDetail(
    name: 'PageView',
    introduction: '可横向或纵向滚动的页面视图。',
    code: '''PageView(
  controller: PageController(initialPage: 0),
  onPageChanged: (index) => print('切换到 \$index'),
  children: [ItemPage(1), ItemPage(2), ItemPage(3)],
)''',
  ),
  'Placeholder': ComponentDetail(
    name: 'Placeholder',
    introduction: '在布局中临时占位。',
    code: '''Placeholder(
  color: Colors.grey,
  strokeWidth: 2,
  fallbackWidth: 200,
  fallbackHeight: 100,
)''',
  ),
  'PopupMenuButton': ComponentDetail(
    name: 'PopupMenuButton',
    introduction: '点击弹出菜单。',
    code: '''PopupMenuButton<String>(
  onSelected: (value) => print('选择: \$value'),
  itemBuilder: (context) => [
    PopupMenuItem(value: 'a', child: Text('选项 A')),
    PopupMenuItem(value: 'b', child: Text('选项 B')),
  ],
  child: Icon(Icons.more_vert),
)''',
  ),
  'Positioned': ComponentDetail(
    name: 'Positioned',
    introduction: '在 Stack 中绝对定位子组件。',
    code: '''Stack(
  children: [
    Positioned(
      left: 10, top: 10,
      child: Container(width: 50, height: 50, color: Colors.blue),
    ),
  ],
)''',
    notes: [
      '只能用于 Stack',
      '不要同时设置 left+right 与 top+bottom，可能冲突'
    ],
  ),
  'ProgressIndicator': ComponentDetail(
    name: 'ProgressIndicator',
    introduction: '进度指示器基类，通常用 Linear 或 Circular。',
    code: '''CircularProgressIndicator(
  value: 0.5,
  color: Colors.blue,
  backgroundColor: Colors.grey[200],
)''',
  ),
};
