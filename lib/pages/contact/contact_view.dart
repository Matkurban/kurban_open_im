import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';
import 'package:kurban_open_im/pages/contact/widgets/friend_list_item.dart';
import 'package:kurban_open_im/pages/contact/widgets/group_list_item.dart';

class ContactView extends GetView<ContactLogic> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("联系人"),
          actions: [
            IconButton(onPressed: () => Get.toNamed('/friend_add'), icon: const Icon(Icons.person_add_alt_1)),
            IconButton(onPressed: () => Get.toNamed('/friend_applications'), icon: const Icon(Icons.notifications)),
            IconButton(onPressed: () => Get.toNamed('/blacklist'), icon: const Icon(Icons.block)),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'group_create') Get.toNamed('/group_create');
                if (v == 'group_search') Get.toNamed('/group_search');
                if (v == 'group_applications') Get.toNamed('/group_applications');
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'group_create', child: Text('创建群')),
                PopupMenuItem(value: 'group_search', child: Text('搜索群')),
                PopupMenuItem(value: 'group_applications', child: Text('入群申请')),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "好友"),
              Tab(text: "群组"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              return ListView.builder(
                itemCount: controller.friends.length,
                itemBuilder: (context, index) {
                  final u = controller.friends[index];
                  return FriendListItem(user: u);
                },
              );
            }),
            Obx(() {
              return ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  final g = controller.groups[index];
                  return GroupListItem(group: g);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
