import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_search_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class FriendSearchView extends GetView<FriendSearchLogic> {
  const FriendSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("添加好友")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.keywordController,
              decoration: const InputDecoration(labelText: "昵称/用户ID"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => FilledButton(
                      onPressed: controller.searching.value
                          ? null
                          : controller.search,
                      child: Text(controller.searching.value ? "搜索中" : "搜索"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.reasonController,
              decoration: const InputDecoration(labelText: "验证信息"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.results.isEmpty) {
                  return const Center(child: Text("搜索结果将显示在这里"));
                }
                return ListView.separated(
                  itemCount: controller.results.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    final name =
                        item.nickname ?? item.remark ?? item.userID ?? "";
                    final disabled =
                        controller.isAlreadyFriend(item) ||
                        controller.isSelf(item);
                    return ListTile(
                      leading: AvatarView(url: item.faceURL, name: name),
                      title: Text(name),
                      subtitle: Text(item.userID ?? ""),
                      trailing: ElevatedButton(
                        onPressed: disabled || controller.sending.value
                            ? null
                            : () => controller.sendRequest(item),
                        child: Text(disabled ? "已是好友" : "添加"),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
