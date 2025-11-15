import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/mine/mine_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class MineView extends GetView<MineLogic> {
  const MineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("我的")),
      body: Obx(() {
        final u = userInfo.value;
        return Column(
          children: [
            ListTile(
              leading: AvatarView(url: u.faceURL, name: u.showName),
              title: Text(u.showName),
              subtitle: Text("ID: ${u.userID}"),
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("我的资料"),
              onTap: () => Get.toNamed('/profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("退出登录"),
              onTap: controller.logout,
            ),
          ],
        );
      }),
    );
  }
}
