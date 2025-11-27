import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_detail_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class FriendDetailView extends GetView<FriendDetailLogic> {
  const FriendDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("好友详情"),
        actions: [IconButton(onPressed: controller.refreshInfo, icon: const Icon(Icons.refresh))],
      ),
      body: Obx(() {
        final info = controller.info.value;
        if (info == null) {
          return const Center(child: Text("好友信息缺失"));
        }
        return RefreshIndicator(
          onRefresh: controller.refreshInfo,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: AvatarView(
                  url: info.faceURL,
                  name: info.nickname ?? info.userID ?? "",
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  info.nickname ?? info.userID ?? "",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ID: ${info.userID ?? ''}"),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () async {
                        final id = info.userID;
                        if (id != null) {
                          await Clipboard.setData(ClipboardData(text: id));
                          Get.snackbar("提示", "ID已复制");
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text("备注名"),
                subtitle: Text(info.remark ?? "暂无"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showRemarkDialog(context, info.remark ?? ""),
                ),
              ),
              ListTile(title: const Text("更多资料"), subtitle: Text(info.ex ?? "")),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text("发送消息"),
                onTap: controller.openChat,
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined),
                title: Text(controller.isBlacklisted ? "移出黑名单" : "加入黑名单"),
                onTap: controller.operating.value
                    ? null
                    : (controller.isBlacklisted
                          ? controller.removeFromBlacklist
                          : controller.addBlacklist),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text("删除好友"),
                onTap: controller.operating.value ? null : controller.deleteFriend,
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showRemarkDialog(BuildContext context, String initial) async {
    final ctrl = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("修改备注"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: "备注"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text("保存"),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await controller.updateRemark(result);
    }
  }
}
