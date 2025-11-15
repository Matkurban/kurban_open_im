import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_applications_logic.dart';

class GroupApplicationsView extends GetView<GroupApplicationsLogic> {
  const GroupApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('入群申请')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '收到'),
                Tab(text: '发出'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const Center(child: Text('暂未加载申请数据')),
                  const Center(child: Text('暂未加载申请数据')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
