import '../models/component_detail.dart';

const Map<String, ComponentDetail> rsData = {
  'Radio': ComponentDetail(
    name: 'Radio',
    introduction: '单选按钮组件。',
    code: '''int? _selected = 1;

Radio<int>(
  value: 1,
  groupValue: _selected,
  onChanged: (v) => setState(() => _selected = v),
)''',
    notes: [
      '通常配合 Row 或 Column 使用多个 Radio，共享 groupValue 实现单选'
    ],
  ),
  'RadioListTile': ComponentDetail(
    name: 'RadioListTile',
    introduction: 'Radio + ListTile 组合。',
    code: '''RadioListTile<int>(
  value: 1,
  groupValue: _selected,
  onChanged: (v) => setState(() => _selected = v),
  title: Text('选项 1'),
  subtitle: Text('描述'),
)''',
  ),
  'RefreshIndicator': ComponentDetail(
    name: 'RefreshIndicator',
    introduction: 'Material 下拉刷新组件。',
    code: '''RefreshIndicator(
  onRefresh: () async {
    await Future.delayed(Duration(seconds: 1));
  },
  child: ListView.builder(itemCount: 20, itemBuilder: (context, i) => ListTile(title: Text('Item \$i'))),
)''',
    notes: [
      '子组件必须是 ScrollView'
    ],
  ),
  'ReorderableListView': ComponentDetail(
    name: 'ReorderableListView',
    introduction: '支持拖拽重新排序的列表。',
    code: '''ReorderableListView(
  onReorder: (oldIndex, newIndex) {
    print('从 \$oldIndex 移动到 \$newIndex');
  },
  children: List.generate(5, (i) => ListTile(
    key: ValueKey(i),
    title: Text('Item \$i'),
    leading: Icon(Icons.drag_handle),
  )),
)''',
  ),
  'RichText': ComponentDetail(
    name: 'RichText',
    introduction: '展示多种样式的文本。',
    code: '''RichText(
  text: TextSpan(
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(text: '红色', style: TextStyle(color: Colors.red)),
      TextSpan(text: ' 蓝色', style: TextStyle(color: Colors.blue)),
      TextSpan(text: ' 默认色'),
    ],
  ),
)''',
  ),
  'RotatedBox': ComponentDetail(
    name: 'RotatedBox',
    introduction: '旋转子组件（角度以 1/4 圈为单位）。',
    code: '''RotatedBox(
  quarterTurns: 1, // 顺时针旋转 90 度
  child: Text('旋转'),
)''',
  ),
  'Row': ComponentDetail(
    name: 'Row',
    introduction: '水平线性布局。',
    code: '''Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [Icon(Icons.star), Text('Hello'), ElevatedButton(onPressed: () {}, child: Text('OK'))],
)''',
    notes: [
      '不自动换行，溢出会报错，换行需用 Wrap 替代'
    ],
  ),
  'Scaffold': ComponentDetail(
    name: 'Scaffold',
    introduction: '页面脚手架，提供标准页面结构。',
    code: '''Scaffold(
  appBar: AppBar(title: Text('标题')),
  body: Center(child: Text('内容')),
  bottomNavigationBar: BottomNavigationBar(items: [...]),
  floatingActionButton: FloatingActionButton(onPressed: () {}),
)''',
    notes: [
      '一个完整的 Material 页面必需的基础框架'
    ],
  ),
  'SafeArea': ComponentDetail(
    name: 'SafeArea',
    introduction: '自动适配系统安全区域（刘海、状态栏、键盘等）。',
    code: '''SafeArea(
  top: true,
  bottom: true,
  child: Text('避开刘海屏的内容'),
)''',
  ),
  'Semantics': ComponentDetail(
    name: 'Semantics',
    introduction: '为组件提供无障碍语义信息。',
    code: '''Semantics(
  label: '关闭按钮',
  hint: '双击关闭应用',
  button: true,
  child: IconButton(icon: Icon(Icons.close), onPressed: () {}),
)''',
  ),
  'Shimmer': ComponentDetail(
    name: 'Shimmer',
    introduction: '加载状态的骨架屏效果（通常需三方包）。',
    code: '''// 示例逻辑
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(width: 200, height: 20, color: Colors.white),
)''',
  ),
  'SingleChildScrollView': ComponentDetail(
    name: 'SingleChildScrollView',
    introduction: '单个子组件的滚动容器。',
    code: '''SingleChildScrollView(
  padding: EdgeInsets.all(16),
  child: Column(children: List.generate(50, (i) => Text('Item \$i'))),
)''',
    notes: [
      '适用于内容不确定但不会极长的场景'
    ],
  ),
  'SizedBox': ComponentDetail(
    name: 'SizedBox',
    introduction: '指定固定宽高的盒子。',
    code: '''SizedBox(
  width: 100, height: 50,
  child: ElevatedButton(onPressed: () {}, child: Text('按钮')),
)''',
    notes: [
      '常用方式：SizedBox.shrink() (零尺寸), SizedBox.expand() (撑满)'
    ],
  ),
  'Slider': ComponentDetail(
    name: 'Slider',
    introduction: '滑块输入组件。',
    code: '''double _value = 0.5;

Slider(
  value: _value,
  onChanged: (v) => setState(() => _value = v),
  min: 0, max: 1,
  divisions: 10,
  label: (_value * 100).round().toString(),
)''',
  ),
  'SnackBar': ComponentDetail(
    name: 'SnackBar',
    introduction: '底部临时提示条。',
    code: '''ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('操作成功'),
    action: SnackBarAction(label: '撤销', onPressed: () {}),
  ),
)''',
    notes: [
      'ScaffoldMessenger 用于管理显示，不再使用传统的 Scaffold.of'
    ],
  ),
  'Stack': ComponentDetail(
    name: 'Stack',
    introduction: '层叠排列子组件。',
    code: '''Stack(
  children: [
    Container(width: 200, height: 200, color: Colors.red),
    Positioned(right: 10, bottom: 10, child: Icon(Icons.star, color: Colors.white)),
  ],
)''',
    notes: [
      '子组件按顺序绘制，后者覆盖前者'
    ],
  ),
  'StreamBuilder': ComponentDetail(
    name: 'StreamBuilder',
    introduction: '基于 Stream 状态构建 UI。',
    code: '''StreamBuilder<int>(
  stream: _counterStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
    return Text('计数: \${snapshot.data}');
  },
)''',
  ),
  'Switch': ComponentDetail(
    name: 'Switch',
    introduction: '开关切换组件。',
    code: '''bool _enabled = false;

Switch(
  value: _enabled,
  onChanged: (v) => setState(() => _enabled = v),
)''',
  ),
  'SwitchListTile': ComponentDetail(
    name: 'SwitchListTile',
    introduction: 'Switch + ListTile 组合。',
    code: '''SwitchListTile(
  value: _enabled,
  onChanged: (v) => setState(() => _enabled = v),
  title: Text('启用通知'),
  secondary: Icon(Icons.notifications),
)''',
  ),
};
