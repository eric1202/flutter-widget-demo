import '../models/component_detail.dart';

const Map<String, ComponentDetail> tData = {
  'TabBar': ComponentDetail(
    name: 'TabBar',
    introduction: '配合 TabBarView 使用，用于切换不同内容。',
    code: '''TabBar(
  controller: _tabController,
  tabs: [
    Tab(icon: Icon(Icons.home), text: '首页'),
    Tab(icon: Icon(Icons.search), text: '搜索'),
    Tab(icon: Icon(Icons.person), text: '我的'),
  ],
)''',
    notes: [
      '通常放在 AppBar.bottom 中'
    ],
  ),
  'TabBarView': ComponentDetail(
    name: 'TabBarView',
    introduction: '与 TabBar 联动切换内容。',
    code: '''TabBarView(
  controller: _tabController,
  children: [Page1(), Page2(), Page3()],
)''',
  ),
  'TabController': ComponentDetail(
    name: 'TabController',
    introduction: '控制 TabBar 和 TabBarView 的切换。',
    code: '''TabController(length: 3, vsync: this) // 在 StatefulWidget 中初始化''',
    notes: [
      '必须在 TickerProviderStateMixin 的 State 中使用',
      'dispose 时需手动释放'
    ],
  ),
  'Text': ComponentDetail(
    name: 'Text',
    introduction: '文本显示组件。',
    code: '''Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)''',
    parameters: [
      'style：TextStyle 控制样式',
      'textAlign：对齐方式',
      'overflow：溢出处理'
    ],
  ),
  'TextButton': ComponentDetail(
    name: 'TextButton',
    introduction: '纯文本样式的按钮。',
    code: '''TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(foregroundColor: Colors.blue),
  child: Text('文本按钮'),
)''',
  ),
  'TextField': ComponentDetail(
    name: 'TextField',
    introduction: '可编辑的文本输入框。',
    code: '''TextField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: '用户名',
    hintText: '请输入用户名',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) => print(value),
)''',
    parameters: [
      'decoration：样式装饰',
      'keyboardType：键盘类型'
    ],
  ),
  'TextFormField': ComponentDetail(
    name: 'TextFormField',
    introduction: 'TextField 的表单封装，支持验证。',
    code: '''TextFormField(
  decoration: InputDecoration(labelText: '邮箱'),
  validator: (v) => v?.contains('@') ?? false ? null : '请输入有效邮箱',
)''',
  ),
  'TimePicker': ComponentDetail(
    name: 'TimePicker',
    introduction: '系统时间选择器。',
    code: '''ElevatedButton(
  onPressed: () async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    print(time);
  },
  child: Text('选择时间'),
)''',
  ),
  'Tooltip': ComponentDetail(
    name: 'Tooltip',
    introduction: '长按或鼠标悬停时显示提示。',
    code: '''Tooltip(
  message: '这是提示信息',
  child: Icon(Icons.help_outline),
)''',
  ),
  'Transform': ComponentDetail(
    name: 'Transform',
    introduction: '对子组件进行投影变换（旋转、缩放、平移）。',
    code: '''Transform(
  transform: Matrix4.identity()..rotateZ(0.1)..scale(1.2),
  alignment: Alignment.center,
  child: Container(width: 100, height: 100, color: Colors.blue),
)''',
    notes: [
      'Transform 只是视觉变换，不影响布局尺寸',
      '需配合 alignment 定位变换中心'
    ],
  ),
  'TweenAnimationBuilder': ComponentDetail(
    name: 'TweenAnimationBuilder',
    introduction: '通用的补间动画组件。',
    code: '''TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 1),
  duration: Duration(milliseconds: 500),
  builder: (context, value, child) {
    return Opacity(opacity: value, child: child);
  },
  child: Text('渐显内容'),
)''',
  ),
};
