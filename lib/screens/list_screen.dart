import 'package:flutter/material.dart';

/// ListScreen 展示了 Flutter 中最常用的列表组件 ListView 的各种用法。
/// 列表是移动应用中展示大量数据最常用的形式。
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView 详解')),
      // 使用 DefaultTabController 来展示不同类型的 ListView
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '基础用法'),
                Tab(text: 'Builder 动态构建'),
                Tab(text: 'Separated 分割线'),
                Tab(text: '横向滚动'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBasicList(context),
                  _buildBuilderList(),
                  _buildSeparatedList(),
                  Column(
                    children: [
                      _buildHorizontalList(alignment: Alignment.topLeft),
                      _buildHorizontalList(alignment: Alignment.topCenter),
                      _buildHorizontalList(alignment: Alignment.topRight),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. 基础用法：适用于子组件较少的场景
  /// 这种方式会一次性加载所有子组件，数据量大时会有性能问题
  Widget _buildBasicList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.star, color: Colors.orange),
          title: Text('基础内容 1'),
          subtitle: Text('直接使用 ListView 的 children 属性'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.star, color: Colors.orange),
          title: Text('基础内容 2'),
          subtitle: Text('适合子项目数量固定的列表'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.star, color: Colors.orange),
          title: Text('基础内容 3'),
          subtitle: Text('可以包含任何 Widget'),
        ),
        //borderRow
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text('基础内容 4'),
              Text('基础内容 5'),
              //spacer
              Spacer(),
              //button click back to home
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ], // Row 的 children 结束
          ), // Row 结束
        ),
        // 甚至可以在列表里放一张图片或一个容器
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('列表里也可以放卡片组件'),
          ),
        ),
      ],
    );
  }

  /// 2. ListView.builder：高性能的动态列表
  /// 只有当子组件滚动到屏幕可见区域时，才会进行构建。适合大数据量。
  Widget _buildBuilderList() {
    return ListView.builder(
      itemCount: 50, // 列表子项目的总数
      itemBuilder: (context, index) {
        // 根据 index 返回对应的 Widget
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            child: Text('${index + 1}'),
          ),
          title: Text('动态项目 ${index + 1}'),
          subtitle: Text('这是通过 builder 实时构建的第 $index 个组件'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // 获取 ScaffoldMessengerState，避免在回调中使用可能已失效的 context
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            
            // 点击交互, 上方弹窗一个自定义toast 提示index 2s 后dissmiss
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('点击了第 $index 个项目'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: '取消',
                  onPressed: () {
                    // 使用之前捕获的 scaffoldMessenger
                    scaffoldMessenger.hideCurrentSnackBar();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 3. ListView.separated：带分割线的列表
  /// 在 builder 的基础上，增加了一个 separatorBuilder 专门用于构建分割线
  Widget _buildSeparatedList() {
    return ListView.separated(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(title: Text('有分割线的项目 $index'));
      },
      // 分割线构造器, 用于构建分割线
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: const Color.fromARGB(255, 9, 23, 229),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        );
      },
    );
  }

  /// 4. 横向滚动列表
  /// 通过设置 scrollDirection 属性实现
  Widget _buildHorizontalList({Alignment alignment = Alignment.center}) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        height: 200, // 横向列表必须指定高度
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 设置为横向
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              width: 160,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                //index 构建随机颜色
                color: [
                  Colors.amber,
                  Colors.blue,
                  Colors.green,
                  Colors.red,
                ][index % 4],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '卡片 $index',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
