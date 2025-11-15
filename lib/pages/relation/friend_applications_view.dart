import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'friend_applications_logic.dart';

class FriendApplicationsView extends GetView<FriendApplicationsLogic> {
  const FriendApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('好友申请')),
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
