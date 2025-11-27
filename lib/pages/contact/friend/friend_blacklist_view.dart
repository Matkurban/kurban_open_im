import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_blacklist_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class FriendBlacklistView extends GetView<FriendBlacklistLogic> {
  const FriendBlacklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("黑名单"),
        actions: [IconButton(onPressed: controller.loadBlacklist, icon: const Icon(Icons.refresh))],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.blacklist.isEmpty) {
          return const Center(child: Text("暂无黑名单用户"));
        }
        return ListView.separated(
          itemCount: controller.blacklist.length,
          separatorBuilder: (context, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = controller.blacklist[index];
            final name = item.nickname ?? item.userID ?? "";
            return ListTile(
              leading: AvatarView(url: item.faceURL, name: name),
              title: Text(name),
              subtitle: Text(item.userID ?? ""),
              trailing: TextButton(
                onPressed: () => controller.remove(item),
                child: const Text("移出"),
              ),
            );
          },
        );
      }),
    );
  }
}
