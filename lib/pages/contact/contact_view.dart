import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';
import 'package:kurban_open_im/pages/contact/widgets/friend_list_item.dart';
import 'package:kurban_open_im/pages/contact/widgets/group_list_item.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/widgets/unread_badge.dart';

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
            IconButton(
              onPressed: () => Get.toNamed(RouterName.friendSearch),
              icon: const Icon(Icons.person_add_alt_1),
            ),
            Obx(() {
              final count = controller.pendingFriendCount.value;
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () => Get.toNamed(RouterName.friendApplications),
                    icon: const Icon(Icons.notifications_none),
                  ),
                  if (count > 0) Positioned(right: 6, top: 6, child: UnreadBadge(count: count)),
                ],
              );
            }),
            IconButton(
              onPressed: () => Get.toNamed(RouterName.friendBlacklist),
              icon: const Icon(Icons.block_outlined),
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
