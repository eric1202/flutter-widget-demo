import '../models/component_detail.dart';

const Map<String, ComponentDetail> gData = {
  'GestureDetector': ComponentDetail(
    name: 'GestureDetector',
    introduction: '检测各种手势（点击、滑动、长按等）。',
    code: '''GestureDetector(
  onTap: () => print('单击'),
  onDoubleTap: () => print('双击'),
  onLongPress: () => print('长按'),
  onPanUpdate: (details) => print('拖拽 \${details.delta}'),
  child: Container(width: 200, height: 200, color: Colors.blue),
)''',
    notes: [
      'GestureDetector 本身没有视觉外观，需要包裹有尺寸的子组件',
      '多个手势同时存在时注意冲突'
    ],
  ),
  'GlobalKey': ComponentDetail(
    name: 'GlobalKey',
    introduction: '用于跨组件访问 State 或 Element。',
    code: '''final _myKey = GlobalKey<MyWidgetState>();

MyWidget(key: _myKey);
// 在其他位置访问
_myKey.currentState?.doSomething();''',
    notes: [
      '滥用 GlobalKey 会破坏组件封装，增加耦合',
      '仅在必要时使用，如获取第三方组件的 state'
    ],
  ),
  'GridView': ComponentDetail(
    name: 'GridView',
    introduction: '网格列表组件。',
    code: '''GridView.count(
  crossAxisCount: 3, // 每行数量
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  children: List.generate(20, (i) => Container(color: Colors.blue, child: Center(child: Text('Item \$i')))),
)''',
    notes: [
      '默认不可滚动，可放在 Expanded 或有尺寸约束的容器中',
      'GridView.builder：高效构建大量数据'
    ],
  ),
};
