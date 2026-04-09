import '../models/component_detail.dart';

const Map<String, ComponentDetail> uvwData = {
  'UnconstrainedBox': ComponentDetail(
    name: 'UnconstrainedBox',
    introduction: '移除父容器的约束，让子组件按自身需求布局。',
    code: '''UnconstrainedBox(
  child: Container(width: 1000, height: 50, color: Colors.red),
)''',
    notes: [
      '子组件超出父容器会导致溢出警告'
    ],
  ),
  'ValueListenableBuilder': ComponentDetail(
    name: 'ValueListenableBuilder',
    introduction: '监听 ValueListenable 变化时重建 UI，精细控制重建范围。',
    code: '''ValueNotifier<int> _counter = ValueNotifier<int>(0);

ValueListenableBuilder<int>(
  valueListenable: _counter,
  builder: (context, value, child) {
    return Text('计数: \$value');
  },
)''',
  ),
  'VerticalDivider': ComponentDetail(
    name: 'VerticalDivider',
    introduction: '垂直分割线。',
    code: '''VerticalDivider(
  thickness: 1,
  width: 20,
  color: Colors.grey[300],
)''',
  ),
  'Visibility': ComponentDetail(
    name: 'Visibility',
    introduction: '灵活控制子组件的显示与隐藏，可决定是否保持状态。',
    code: '''Visibility(
  visible: _isVisible,
  maintainState: true,
  maintainSize: false,
  child: Text('隐藏时释放空间的内容'),
)''',
    notes: [
      '完全隐藏并释放空间：maintainSize: false（默认）',
      '隐藏但占位：maintainSize: true'
    ],
  ),
  'Wrap': ComponentDetail(
    name: 'Wrap',
    introduction: '自动换行布局。',
    code: '''Wrap(
  spacing: 8,
  runSpacing: 4,
  alignment: WrapAlignment.center,
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Material')),
  ],
)''',
    parameters: [
      'spacing：水平间距',
      'runSpacing：行间距',
      'alignment：对齐方式'
    ],
  ),
};
