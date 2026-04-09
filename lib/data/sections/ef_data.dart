import '../models/component_detail.dart';

const Map<String, ComponentDetail> efData = {
  'ElevatedButton': ComponentDetail(
    name: 'ElevatedButton',
    introduction: 'Material Design 风格的高亮按钮。',
    code: '''ElevatedButton(
  onPressed: () => print('点击'),
  onLongPress: () => print('长按'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: Text('确定'),
)''',
    notes: [
      'onPressed 为 null 时表示禁用状态',
      '尽量使用 styleFrom 而非 ButtonStyle 的构造方式，更简洁'
    ],
  ),
  'Expanded': ComponentDetail(
    name: 'Expanded',
    introduction: '在 Row、Column、Flex 中弹性填充剩余空间。',
    code: '''Row(
  children: [
    Expanded(flex: 2, child: Container(color: Colors.red, height: 50)),
    Expanded(flex: 1, child: Container(color: Colors.blue, height: 50)),
  ],
)''',
    notes: [
      '只能用于 Flex 及其子类（Row、Column）',
      '不能嵌套在 ListView / GridView 的 sliver 中使用'
    ],
  ),
  'FadeTransition': ComponentDetail(
    name: 'FadeTransition',
    introduction: '使用 AnimationController 控制透明度的过渡动画。',
    code: '''FadeTransition(
  opacity: _controller,
  child: Container(width: 100, height: 100, color: Colors.blue),
)''',
  ),
  'Flexible': ComponentDetail(
    name: 'Flexible',
    introduction: '与 Expanded 类似，但允许子组件不完全填满剩余空间。',
    code: '''Row(
  children: [
    Flexible(
      fit: FlexFit.loose, // 或 FlexFit.tight
      child: Container(width: 50, color: Colors.red),
    ),
    Container(width: 100, color: Colors.blue),
  ],
)''',
    parameters: [
      'fit：FlexFit.tight（强制填满）或 FlexFit.loose（允许更小）',
      'flex：弹性系数'
    ],
    notes: [
      'Expanded 是 Flexible 的特例（fit: FlexFit.tight）'
    ],
  ),
  'FittedBox': ComponentDetail(
    name: 'FittedBox',
    introduction: '缩放子组件以适应父容器。',
    code: '''FittedBox(
  fit: BoxFit.contain, // 或 cover, fill, none 等
  child: Text('很长的一行文字'),
)''',
    parameters: [
      'fit：BoxFit 枚举'
    ],
  ),
  'FloatingActionButton': ComponentDetail(
    name: 'FloatingActionButton',
    introduction: '浮动操作按钮。',
    code: '''FloatingActionButton(
  onPressed: () => print('FAB点击'),
  tooltip: '添加',
  child: Icon(Icons.add),
  heroTag: 'fab1', // 同页面多 FAB 时必须不同
)''',
    notes: [
      '一个页面通常只有一个 FAB',
      'heroTag 在同一页面有多个 FAB 时必须唯一'
    ],
  ),
  'Flow': ComponentDetail(
    name: 'Flow',
    introduction: '自定义流式布局，需要 FlowDelegate。',
    code: '''Flow(
  delegate: _MyFlowDelegate(),
  children: List.generate(5, (i) => Container(width: 50, height: 50, color: Colors.blue)),
)''',
    notes: [
      '适合自定义复杂布局，普通场景用 Wrap 即可'
    ],
  ),
  'Form': ComponentDetail(
    name: 'Form',
    introduction: '包含多个输入字段的表单容器，配合 FormField 使用。',
    code: '''final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(validator: (v) => v?.isEmpty ?? true ? '不能为空' : null),
    ElevatedButton(onPressed: () => _formKey.currentState!.validate(), child: Text('提交')),
  ]),
)''',
    notes: [
      'Form.save() / Form.validate() 会自动调用所有子 FormField 的方法'
    ],
  ),
  'FutureBuilder': ComponentDetail(
    name: 'FutureBuilder',
    introduction: '基于 Future 状态构建 UI。',
    code: '''FutureBuilder<String>(
  future: _fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
    if (snapshot.hasError) return Text('错误: \${snapshot.error}');
    return Text('数据: \${snapshot.data}');
  },
)''',
    parameters: [
      'future：异步计算',
      'builder：构建函数，接收 AsyncSnapshot'
    ],
    notes: [
      'future 变化时会重建'
    ],
  ),
};
