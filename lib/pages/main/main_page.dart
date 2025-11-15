import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_view.dart';
import 'package:kurban_open_im/pages/conversation/conversation_view.dart';
import 'package:kurban_open_im/pages/main/main_logic.dart';
import 'package:kurban_open_im/pages/mine/mine_view.dart';

class MainPage extends GetView<MainLogic> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.mainPageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [const ConversationView(), const ContactView(), const MineView()],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
              activeIcon: Icon(Icons.contacts),
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
