import 'package:flutter/material.dart';
import '../data/component_data.dart';

class PdfStudyScreen extends StatefulWidget {
  const PdfStudyScreen({super.key});

  @override
  State<PdfStudyScreen> createState() => _PdfStudyScreenState();
}

class _PdfStudyScreenState extends State<PdfStudyScreen> {
  final Map<String, List<String>> _allComponents = {
    'A': [
      'AlertDialog', 'Align', 'AnimatedAlign', 'AnimatedBuilder', 'AnimatedContainer',
      'AnimatedCrossFade', 'AnimatedOpacity', 'AnimatedPadding', 'AnimatedPositioned',
      'AnimatedSize', 'AspectRatio', 'AppBar'
    ],
    'B': ['BackdropFilter', 'Baseline', 'BottomNavigationBar', 'BottomSheet', 'Builder', 'ButtonBar'],
    'C': [
      'Card', 'Checkbox', 'CheckboxListTile', 'Chip', 'CircleAvatar', 'ClipOval',
      'ClipRRect', 'ClipRect', 'ColorFiltered', 'Column', 'ConstrainedBox', 'Container'
    ],
    'D': ['DataTable', 'DatePicker', 'DefaultTextStyle', 'Dismissible', 'DragTarget', 'Draggable', 'Drawer', 'DropdownButton'],
    'E': ['ElevatedButton', 'Expanded'],
    'F': ['FadeTransition', 'Flexible', 'FittedBox', 'FloatingActionButton', 'Flow', 'Form', 'FutureBuilder'],
    'G': ['GestureDetector', 'GlobalKey', 'GridView'],
    'H': ['Hero', 'HorizontalDivider'],
    'I': ['Icon', 'IconButton', 'Image', 'IndexedStack', 'InteractiveViewer'],
    'L': ['LayoutBuilder', 'LimitedBox', 'LinearProgressIndicator', 'ListTile', 'ListView', 'LongPressDraggable'],
    'M': ['MediaQuery'],
    'N': ['NavigationBar', 'Navigator', 'NotificationListener'],
    'O': ['Opacity', 'OutlinedButton', 'OverflowBox'],
    'P': ['Padding', 'PageView', 'Placeholder', 'PopupMenuButton', 'Positioned', 'ProgressIndicator'],
    'R': ['Radio', 'RadioListTile', 'RefreshIndicator', 'ReorderableListView', 'RichText', 'RotatedBox', 'Row'],
    'S': [
      'Scaffold', 'SafeArea', 'Semantics', 'Shimmer', 'SingleChildScrollView', 'SizedBox',
      'Slider', 'SnackBar', 'Stack', 'StreamBuilder', 'Switch', 'SwitchListTile'
    ],
    'T': [
      'TabBar', 'TabBarView', 'TabController', 'Text', 'TextButton', 'TextField',
      'TextFormField', 'TimePicker', 'Tooltip', 'Transform', 'TweenAnimationBuilder'
    ],
    'U': ['UnconstrainedBox'],
    'V': ['ValueListenableBuilder', 'VerticalDivider', 'Visibility'],
    'W': ['Wrap'],
  };

  late Map<String, List<String>> _filteredComponents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredComponents = Map.from(_allComponents);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredComponents = Map.from(_allComponents);
      } else {
        _filteredComponents = {};
        _allComponents.forEach((key, list) {
          final filteredList = list.where((item) => item.toLowerCase().contains(query)).toList();
          if (filteredList.isNotEmpty) {
            _filteredComponents[key] = filteredList;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = _filteredComponents.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 组件详解析 (A-Z)'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: sortedKeys.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final key = sortedKeys[index];
                      final components = _filteredComponents[key]!;
                      return _buildSection(key, components);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.withOpacity(0.1),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索组件 (例如: Container)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildSection(String letter, List<String> components) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[200],
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: components.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final name = components[index];
            return ListTile(
              title: Text(name),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                _showComponentDetail(name);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '未找到相关组件',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showComponentDetail(String name) {
    final detail = componentDetails[name];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ComponentDetailModal(detail: detail, name: name),
    );
  }
}

class _ComponentDetailModal extends StatelessWidget {
  final ComponentDetail? detail;
  final String name;

  const _ComponentDetailModal({this.detail, required this.name});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    if (detail != null) ...[
                      _SectionTitle(title: '简介'),
                      Text(
                        detail!.introduction,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: '代码示例'),
                      _CodeBlock(code: detail!.code),
                      const SizedBox(height: 24),
                      if (detail!.parameters.isNotEmpty) ...[
                        _SectionTitle(title: '精华属性'),
                        ...detail!.parameters.map((p) => _BulletPoint(text: p)),
                        const SizedBox(height: 24),
                      ],
                      if (detail!.notes.isNotEmpty) ...[
                        _SectionTitle(title: '注意事项'),
                        ...detail!.notes.map((n) => _BulletPoint(text: n, color: Colors.orange)),
                      ],
                    ] else ...[
                      _buildComingSoon(),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.extension, color: Colors.blue, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoon() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(Icons.auto_awesome, size: 64, color: Colors.blue.withOpacity(0.3)),
        const SizedBox(height: 16),
        const Text(
          '该组件的详细资料正在整理中...',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          '请参考 PDF 原文档获取完整信息',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 14,
          color: Color(0xFF24292E),
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final Color color;
  const _BulletPoint({required this.text, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
