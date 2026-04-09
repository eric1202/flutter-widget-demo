import '../models/component_detail.dart';

const Map<String, ComponentDetail> oData = {
  'Opacity': ComponentDetail(
    name: 'Opacity',
    introduction: '控制子组件的透明度。',
    code: '''Opacity(
  opacity: 0.5,
  child: Text('半透明'),
)''',
    notes: [
      'Opacity 仍会绘制子组件，性能差于 Visibility 的隐藏模式',
      '若只需完全隐藏，用 Visibility 更优'
    ],
  ),
  'OutlinedButton': ComponentDetail(
    name: 'OutlinedButton',
    introduction: '带边框的 Material 按钮。',
    code: '''OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.blue),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: Text('边框按钮'),
)''',
  ),
  'OverflowBox': ComponentDetail(
    name: 'OverflowBox',
    introduction: '允许子组件溢出父容器约束。',
    code: '''OverflowBox(
  maxWidth: 300,
  child: Container(width: 400, height: 100, color: Colors.red), // 超出父容器
)''',
    notes: [
      '可能导致布局冲突，谨慎使用'
    ],
  ),
};
