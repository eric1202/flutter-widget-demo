import '../models/component_detail.dart';

const Map<String, ComponentDetail> cData = {
  'Card': ComponentDetail(
    name: 'Card',
    introduction: '带圆角和阴影的卡片容器。',
    code: '''Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(children: [Text('卡片内容')]),
  ),
)''',
    parameters: [
      'elevation：阴影深度（0~24）',
      'shape：形状（默认圆角矩形）',
      'margin：外边距'
    ],
    notes: [
      'Card 内部自动包含 Material 组件',
      '嵌套使用时注意阴影叠加效果'
    ],
  ),
  'Checkbox': ComponentDetail(
    name: 'Checkbox',
    introduction: '复选框组件。',
    code: '''bool _checked = false;

Checkbox(
  value: _checked,
  onChanged: (value) => setState(() => _checked = value ?? false),
)''',
    parameters: [
      'value：当前选中状态',
      'onChanged：状态变化回调',
      'tristate：支持三态（null 表示不确定状态）'
    ],
    notes: [
      'onChanged 为 null 时表示禁用'
    ],
  ),
  'CheckboxListTile': ComponentDetail(
    name: 'CheckboxListTile',
    introduction: 'Checkbox + ListTile 组合，适合列表中使用。',
    code: '''CheckboxListTile(
  value: _checked,
  onChanged: (value) => setState(() => _checked = value ?? false),
  title: Text('同意用户协议'),
  subtitle: Text('点击查看协议详情'),
  secondary: Icon(Icons.description),
)''',
  ),
  'Chip': ComponentDetail(
    name: 'Chip',
    introduction: '小尺寸的标签组件。',
    code: '''Chip(
  label: Text('Flutter'),
  avatar: CircleAvatar(child: Text('F')),
  onDeleted: () {},
  deleteIcon: Icon(Icons.close, size: 16),
)''',
    parameters: [
      'label：标签文字',
      'avatar：左侧头像',
      'onDeleted：删除回调（显示删除图标）'
    ],
  ),
  'CircleAvatar': ComponentDetail(
    name: 'CircleAvatar',
    introduction: '圆形头像组件。',
    code: '''CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  child: Text('W'), // 无图片时显示的文字
)''',
    parameters: [
      'radius：半径',
      'backgroundImage：背景图片'
    ],
  ),
  'ClipOval': ComponentDetail(
    name: 'ClipOval',
    introduction: '将子组件裁剪为椭圆形状。',
    code: '''ClipOval(
  child: Image.network('https://example.com/photo.jpg', width: 100, height: 100),
)''',
    notes: [
      '如果宽高相同则为正圆'
    ],
  ),
  'ClipRRect': ComponentDetail(
    name: 'ClipRRect',
    introduction: '将子组件裁剪为圆角矩形。',
    code: '''ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.network('https://example.com/image.jpg'),
)''',
  ),
  'ClipRect': ComponentDetail(
    name: 'ClipRect',
    introduction: '将子组件裁剪为矩形。',
    code: '''ClipRect(
  child: Align(
    alignment: Alignment.topCenter,
    heightFactor: 0.5,
    child: Image.network('https://example.com/image.jpg'),
  ),
)''',
  ),
  'ColorFiltered': ComponentDetail(
    name: 'ColorFiltered',
    introduction: '对子组件施加颜色变换。',
    code: '''ColorFiltered(
  colorFilter: ColorFilter.mode(Colors.blue, BlendMode.color),
  child: Image.network('https://example.com/image.jpg'),
)''',
  ),
  'Column': ComponentDetail(
    name: 'Column',
    introduction: '垂直线性布局。',
    code: '''Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Icon(Icons.star),
    Text('Hello'),
    ElevatedButton(onPressed: () {}, child: Text('Button')),
  ],
)''',
    parameters: [
      'mainAxisAlignment：主轴对齐（垂直方向）',
      'crossAxisAlignment：交叉轴对齐（水平方向）'
    ],
    notes: [
      'Column 不会自动滚动，超出范围会报错，用 ListView 替代'
    ],
  ),
  'ConstrainedBox': ComponentDetail(
    name: 'ConstrainedBox',
    introduction: '对子组件施加额外约束。',
    code: '''ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 200,
    minHeight: 50,
    maxHeight: 100,
  ),
  child: Container(width: 300, height: 200, color: Colors.red), // 实际受约束为 max
)''',
  ),
  'Container': ComponentDetail(
    name: 'Container',
    introduction: '组合型容器，相当于 div 的角色。',
    code: '''Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white, width: 2),
    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
  ),
  transform: Matrix4.rotationZ(0.1),
  child: Center(child: Text('内容')),
)''',
    notes: [
      'Container 首先应用 constraints，然后是 decoration，最后是 transform',
      '简单场景用 SizedBox / Padding / Align 更高效'
    ],
  ),
};
