import '../models/component_detail.dart';

const Map<String, ComponentDetail> lData = {
  'LayoutBuilder': ComponentDetail(
    name: 'LayoutBuilder',
    introduction: '根据父组件约束动态构建 UI。',
    code: '''LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return Row(children: [Text('侧边栏'), Expanded(child: Text('内容'))]);
    } else {
      return Column(children: [Text('顶部'), Expanded(child: Text('内容'))]);
    }
  },
)''',
  ),
  'LimitedBox': ComponentDetail(
    name: 'LimitedBox',
    introduction: '当父容器无限大时，对子组件施加限制。',
    code: '''LimitedBox(
  maxWidth: 200,
  maxHeight: 100,
  child: Container(color: Colors.blue),
)''',
  ),
  'LinearProgressIndicator': ComponentDetail(
    name: 'LinearProgressIndicator',
    introduction: '水平进度指示器。',
    code: '''LinearProgressIndicator(
  value: 0.7, // 0.0 ~ 1.0
  backgroundColor: Colors.grey[300],
  color: Colors.blue,
)''',
    notes: [
      '无 value 时显示循环动画'
    ],
  ),
  'ListTile': ComponentDetail(
    name: 'ListTile',
    introduction: '标准的列表项组件。',
    code: '''ListTile(
  leading: CircleAvatar(child: Icon(Icons.person)),
  title: Text('标题'),
  subtitle: Text('副标题'),
  trailing: Icon(Icons.chevron_right),
  onTap: () {},
)''',
    notes: [
      '常用于 ListView 的子项'
    ],
  ),
  'ListView': ComponentDetail(
    name: 'ListView',
    introduction: '可滚动的列表视图。',
    code: '''ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) => ListTile(title: Text('Item \$index')),
)''',
    notes: [
      'ListView.builder：高效懒加载',
      '避免在 shrinkWrap: true 且嵌套时性能差'
    ],
  ),
  'LongPressDraggable': ComponentDetail(
    name: 'LongPressDraggable',
    introduction: '长按后才触发拖拽。',
    code: '''LongPressDraggable<String>(
  data: 'item-data',
  feedback: Material(child: Text('拖拽中')),
  child: Container(child: Text('长按拖拽我')),
)''',
  ),
};
