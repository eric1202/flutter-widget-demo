import '../models/component_detail.dart';

const Map<String, ComponentDetail> bData = {
  'BackdropFilter': ComponentDetail(
    name: 'BackdropFilter',
    introduction: '对底层内容施加模糊效果，常用于毛玻璃效果。',
    code: '''Stack(
  children: [
    Image.network('https://example.com/bg.jpg'),
    Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: Colors.white.withOpacity(0.3)),
      ),
    ),
  ],
)''',
    notes: [
      '需要 dart:ui 中的 ImageFilter',
      '性能开销较大，避免在大面积或频繁更新的场景使用',
      '常配合半透明遮罩使用'
    ],
  ),
  'Baseline': ComponentDetail(
    name: 'Baseline',
    introduction: '根据基线对齐子组件，常用于文字对齐。',
    code: '''Baseline(
  baseline: 50,
  baselineType: TextBaseline.alphabetic,
  child: Text('Hello', style: TextStyle(fontSize: 32)),
)''',
    parameters: [
      'baseline：基线位置（从顶部计算）',
      'baselineType：TextBaseline.alphabetic（字母基线）或 TextBaseline.ideographic（表意文字基线）'
    ],
  ),
  'BottomNavigationBar': ComponentDetail(
    name: 'BottomNavigationBar',
    introduction: '底部导航栏，用于多页面切换。',
    code: '''BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
  ],
)''',
    parameters: [
      'currentIndex：当前选中索引',
      'onTap：切换回调',
      'items：导航项列表',
      'type：BottomNavigationBarType.fixed（固定）或 shifting（浮动）'
    ],
    notes: [
      'type 为 shifting 时，未选中项图标会缩小动画',
      '每个 item 的 label 在 type: fixed 时始终显示'
    ],
  ),
  'BottomSheet': ComponentDetail(
    name: 'BottomSheet',
    introduction: '从底部弹出的面板。',
    code: '''showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    height: 300,
    child: Column(children: [Text('底部弹窗内容')]),
  ),
);''',
    parameters: [
      'isDismissible：点击外部是否关闭（默认 true）',
      'enableDrag：是否支持拖拽关闭（默认 true）',
      'isScrollControlled：是否随内容高度变化'
    ],
    notes: [
      'showModalBottomSheet 为模态（阻塞交互），showBottomSheet 为非模态'
    ],
  ),
  'Builder': ComponentDetail(
    name: 'Builder',
    introduction: '一个简单的 InheritedWidget，用于获取 BuildContext 并在回调中构建 UI。',
    code: '''Builder(
  builder: (context) {
    // 在这里可以使用 context 获取主题、媒体查询等
    return Text('当前主题: \${Theme.of(context).brightness}');
  },
)''',
    notes: [
      '当你需要一个新的 BuildContext 但不需要创建新 StatefulWidget 时使用',
      '不会缓存任何东西，每次父组件重建都会重建 Builder'
    ],
  ),
  'ButtonBar': ComponentDetail(
    name: 'ButtonBar',
    introduction: '水平排列的按钮容器，默认右对齐。',
    code: '''ButtonBar(
  alignment: MainAxisAlignment.end,
  children: [
    TextButton(onPressed: () {}, child: Text('取消')),
    ElevatedButton(onPressed: () {}, child: Text('确认')),
  ],
)''',
  ),
};
