import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';
import 'package:kurban_open_im/pages/contact/contact_view.dart';
import 'package:kurban_open_im/pages/conversation/conversation_view.dart';
import 'package:kurban_open_im/pages/main/main_logic.dart';
import 'package:kurban_open_im/pages/mine/mine_view.dart';
import 'package:kurban_open_im/widgets/unread_badge.dart';

class MainPage extends GetView<MainLogic> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactLogic = Get.find<ContactLogic>();
    return Scaffold(
      body: PageView(
        controller: controller.mainPageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const ConversationView(),
          const ContactView(),
          const MineView(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.home_outlined),
                  Positioned(
                    right: -6,
                    top: -2,
                    child: Obx(
                      () => UnreadBadge(
                        count: Get.find<MainLogic>().totalUnread.value,
                      ),
                    ),
                  ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.home),
                  Positioned(
                    right: -6,
                    top: -2,
                    child: Obx(
                      () => UnreadBadge(
                        count: Get.find<MainLogic>().totalUnread.value,
                      ),
                    ),
                  ),
                ],
              ),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                final pending = contactLogic.pendingFriendCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.contacts_outlined),
                    if (pending > 0)
                      Positioned(
                        right: -6,
                        top: -2,
                        child: UnreadBadge(count: pending),
                      ),
                  ],
                );
              }),
              activeIcon: Obx(() {
                final pending = contactLogic.pendingFriendCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.contacts),
                    if (pending > 0)
                      Positioned(
                        right: -6,
                        top: -2,
                        child: UnreadBadge(count: pending),
                      ),
                  ],
                );
              }),
              label: "好友",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "我的",
            ),
          ],
        );
      }),
    );
  }
}
