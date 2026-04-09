import '../models/component_detail.dart';

const Map<String, ComponentDetail> dData = {
  'DataTable': ComponentDetail(
    name: 'DataTable',
    introduction: '展示表格数据的组件。',
    code: '''DataTable(
  columns: [
    DataColumn(label: Text('姓名')),
    DataColumn(label: Text('年龄')),
  ],
  rows: [
    DataRow(cells: [DataCell(Text('张三')), DataCell(Text('25'))]),
    DataRow(cells: [DataCell(Text('李四')), DataCell(Text('30'))]),
  ],
)''',
    notes: [
      '不支持列宽自适应和排序，需配合 PaginatedDataTable 实现分页'
    ],
  ),
  'DatePicker': ComponentDetail(
    name: 'DatePicker',
    introduction: '系统日期选择器。',
    code: '''ElevatedButton(
  onPressed: () async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    print(date);
  },
  child: Text('选择日期'),
)''',
  ),
  'DefaultTextStyle': ComponentDetail(
    name: 'DefaultTextStyle',
    introduction: '为子组件提供默认文本样式。',
    code: '''DefaultTextStyle(
  style: TextStyle(fontSize: 16, color: Colors.black87),
  child: Column(children: [
    Text('使用默认样式'),
    Text('也是默认样式', style: TextStyle(color: Colors.red)), // 可覆盖
  ]),
)''',
  ),
  'Dismissible': ComponentDetail(
    name: 'Dismissible',
    introduction: '子组件可滑动删除。',
    code: '''Dismissible(
  key: UniqueKey(),
  direction: DismissDirection.horizontal,
  background: Container(color: Colors.red, child: Align(alignment: Alignment.centerLeft, child: Icon(Icons.delete, color: Colors.white))),
  secondaryBackground: Container(color: Colors.orange, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.archive, color: Colors.white))),
  onDismissed: (direction) => print('删除 direction=\$direction'),
  child: ListTile(title: Text('滑动我')),
)''',
    parameters: [
      'direction：滑动方向',
      'background：滑动时显示的背景',
      'onDismissed：滑动完成回调'
    ],
  ),
  'DragTarget': ComponentDetail(
    name: 'DragTarget',
    introduction: '接收 Draggable 拖拽的组件。',
    code: '''DragTarget<String>(
  onAcceptWithDetails: (details) => print('收到: \${details.data}'),
  builder: (context, candidateData, rejectedData) {
    return Container(
      width: 150, height: 150,
      color: candidateData.isNotEmpty ? Colors.green : Colors.grey,
      child: Center(child: Text('拖拽到这里')),
    );
  },
)''',
  ),
  'Draggable': ComponentDetail(
    name: 'Draggable',
    introduction: '可拖拽的组件。',
    code: '''Draggable<String>(
  data: 'hello',
  feedback: Material(child: Text('拖拽中', style: TextStyle(color: Colors.white))),
  childWhenDragging: Opacity(opacity: 0.5, child: Text('原位置')),
  child: Text('拖拽我'),
)''',
    parameters: [
      'data：传递的数据',
      'feedback：拖拽过程中显示的组件'
    ],
  ),
  'Drawer': ComponentDetail(
    name: 'Drawer',
    introduction: '侧边抽屉导航面板。',
    code: '''Scaffold(
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('用户信息')),
        ListTile(leading: Icon(Icons.home), title: Text('首页')),
        ListTile(leading: Icon(Icons.settings), title: Text('设置')),
      ],
    ),
  ),
)''',
    notes: [
      '从左侧滑出，endDrawer 从右侧滑出',
      '通常放在 Scaffold 中使用'
    ],
  ),
  'DropdownButton': ComponentDetail(
    name: 'DropdownButton',
    introduction: '下拉选择框。',
    code: '''String _selected = 'Flutter';

DropdownButton<String>(
  value: _selected,
  items: ['Flutter', 'Dart', 'React Native'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: (value) => setState(() => _selected = value ?? 'Flutter'),
)''',
    parameters: [
      'value：当前选中值',
      'items：下拉选项列表',
      'onChanged：选中回调'
    ],
  ),
};
