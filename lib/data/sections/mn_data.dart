import '../models/component_detail.dart';

const Map<String, ComponentDetail> mnData = {
  'MediaQuery': ComponentDetail(
    name: 'MediaQuery',
    introduction: '获取设备媒体信息（屏幕尺寸、方向、像素比等）。',
    code: '''// 在 build 方法中
Size size = MediaQuery.of(context).size;
double statusBarHeight = MediaQuery.of(context).padding.top;
Orientation orientation = MediaQuery.of(context).orientation;''',
    notes: [
      'MediaQuery.of(context) 在 context 不存在时会抛异常',
      '布局时优先使用 SafeArea 组件处理安全区域'
    ],
  ),
  'NavigationBar': ComponentDetail(
    name: 'NavigationBar',
    introduction: 'Material 3 设计规范的底部导航栏。',
    code: '''NavigationBar(
  selectedIndex: _selectedIndex,
  onTap: (i) => setState(() => _selectedIndex = i),
  destinations: [
    NavigationDestination(icon: Icon(Icons.home), label: '首页'),
    NavigationDestination(icon: Icon(Icons.search), label: '搜索'),
    NavigationDestination(icon: Icon(Icons.person), label: '我的'),
  ],
)''',
    notes: [
      'Material 3 新增，推荐新项目使用'
    ],
  ),
  'Navigator': ComponentDetail(
    name: 'Navigator',
    introduction: '页面导航管理器。',
    code: '''// 压栈
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage()));

// 出栈
Navigator.pop(context);

// 替换当前页
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewPage()));''',
    notes: [
      '通常配合 MaterialApp 使用'
    ],
  ),
  'NotificationListener': ComponentDetail(
    name: 'NotificationListener',
    introduction: '监听特定类型的通知（如滚动通知）。',
    code: '''NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    print('滚动位置: \${notification.metrics.pixels}');
    return true; // 返回 true 阻止冒泡
  },
  child: ListView.builder(itemCount: 100, itemBuilder: (context, i) => ListTile(title: Text('Item \$i'))),
)''',
  ),
};
