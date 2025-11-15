import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/chat_detail/chat_detail_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ChatDetailView extends GetView<ChatDetailLogic> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.title.isEmpty ? '详情' : controller.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(controller),
            const SizedBox(height: 12),
            _ConversationOpsSection(controller, promptText: (ctx, hint) => _promptText(ctx, hint)),
            const SizedBox(height: 12),
            controller.isGroup
                ? _GroupSection(
                    controller,
                    promptText: (ctx, hint) => _promptText(ctx, hint),
                    promptList: (ctx, hint) => _promptList(ctx, hint),
                    confirm: (ctx, title) => _confirm(ctx, title),
                  )
                : _FriendSection(controller, promptText: (ctx, hint) => _promptText(ctx, hint)),
            const SizedBox(height: 24),
            _DangerZoneSection(controller, confirm: (ctx, title) => _confirm(ctx, title)),
          ],
        ),
      ),
    );
  }

  Future<String?> _promptText(BuildContext context, String hint) async {
    final ctrl = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: TextField(
            controller: ctrl,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>?> _promptList(BuildContext context, String hint) async {
    final text = await _promptText(context, hint);
    if (text == null) return null;
    final ids = text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return ids;
  }

  Future<bool?> _confirm(BuildContext context, String title) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('确定')),
          ],
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection(this.controller);
  final ChatDetailLogic controller;
  @override
  Widget build(BuildContext context) {
    if (controller.isGroup) {
      final g = controller.groupInfo.value;
      return Row(
        children: [
          AvatarView(url: g?.faceURL, name: g?.groupName ?? ''),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g?.groupName ?? ''),
                Text(controller.groupID ?? '', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    } else {
      final u = controller.userInfo.value;
      return Row(
        children: [
          AvatarView(url: u?.faceURL, name: u?.nickname ?? u?.userID ?? ''),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u?.nickname ?? u?.userID ?? ''),
                Text(controller.recvID ?? '', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class _ConversationOpsSection extends StatelessWidget {
  const _ConversationOpsSection(this.controller, {required this.promptText});
  final ChatDetailLogic controller;
  final Future<String?> Function(BuildContext, String) promptText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('会话设置', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Obx(
              () => FilterChip(
                label: Text(controller.pinned.value ? '取消置顶' : '置顶会话'),
                selected: controller.pinned.value,
                onSelected: (v) => controller.setPinned(!controller.pinned.value),
              ),
            ),
            Obx(
              () => FilterChip(
                label: Text(controller.recvOpt.value == 1 ? '取消免打扰' : '设置免打扰'),
                selected: controller.recvOpt.value == 1,
                onSelected: (v) =>
                    controller.setRecvOptValue(controller.recvOpt.value == 1 ? 0 : 1),
              ),
            ),
            ActionChip(
              label: const Text('设置草稿'),
              onPressed: () async {
                final text = await promptText(context, '输入草稿内容');
                if (text != null) await controller.setDraft(text);
              },
            ),
            ActionChip(label: const Text('清空会话消息'), onPressed: controller.clearConversation),
            ActionChip(label: const Text('删除会话及消息'), onPressed: controller.deleteConversation),
          ],
        ),
      ],
    );
  }
}

class _FriendSection extends StatelessWidget {
  const _FriendSection(this.controller, {required this.promptText});
  final ChatDetailLogic controller;
  final Future<String?> Function(BuildContext, String) promptText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('好友操作', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('设置备注'),
              onPressed: () async {
                final text = await promptText(context, '输入备注名');
                if (text != null) await controller.setFriendRemark(text);
              },
            ),
            ActionChip(label: const Text('拉黑'), onPressed: controller.addBlacklist),
            ActionChip(label: const Text('移除黑名单'), onPressed: controller.removeBlacklist),
            ActionChip(label: const Text('删除好友'), onPressed: controller.deleteFriend),
          ],
        ),
      ],
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection(
    this.controller, {
    required this.promptText,
    required this.promptList,
    required this.confirm,
  });
  final ChatDetailLogic controller;
  final Future<String?> Function(BuildContext, String) promptText;
  final Future<List<String>?> Function(BuildContext, String) promptList;
  final Future<bool?> Function(BuildContext, String) confirm;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('群操作', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('邀请成员'),
              onPressed: () async {
                final ids = await promptList(context, '输入用户ID，逗号分隔');
                if (ids != null && ids.isNotEmpty) await controller.inviteUsers(ids);
              },
            ),
            ActionChip(
              label: const Text('踢出成员'),
              onPressed: () async {
                final ids = await promptList(context, '输入用户ID，逗号分隔');
                if (ids != null && ids.isNotEmpty) await controller.kickUsers(ids);
              },
            ),
            ActionChip(
              label: const Text('设置管理员'),
              onPressed: () async {
                final uid = await promptText(context, '输入用户ID');
                if (uid != null) await controller.setAdmin(uid, true);
              },
            ),
            ActionChip(
              label: const Text('取消管理员'),
              onPressed: () async {
                final uid = await promptText(context, '输入用户ID');
                if (uid != null) await controller.setAdmin(uid, false);
              },
            ),
            ActionChip(
              label: const Text('禁言成员'),
              onPressed: () async {
                final uid = await promptText(context, '输入用户ID');
                final secStr = await promptText(Get.context!, '禁言秒数');
                final sec = int.tryParse(secStr ?? '0') ?? 0;
                if (uid != null) await controller.muteMember(uid, sec);
              },
            ),
            ActionChip(
              label: const Text('群禁言开关'),
              onPressed: () async {
                final isOn = await confirm(context, '打开群禁言?');
                await controller.muteGroup(isOn == true);
              },
            ),
            ActionChip(
              label: const Text('转让群主'),
              onPressed: () async {
                final uid = await promptText(context, '输入新群主用户ID');
                if (uid != null) await controller.transferOwner(uid);
              },
            ),
            ActionChip(
              label: const Text('修改群信息'),
              onPressed: () async {
                final name = await promptText(context, '群名称(留空不改)');
                final faceURL = await promptText(Get.context!, '群头像URL(留空不改)');
                final notification = await promptText(Get.context!, '群公告(留空不改)');
                await controller.setGroupInfo(
                  name: name,
                  faceURL: faceURL,
                  notification: notification,
                );
              },
            ),
            ActionChip(label: const Text('退出群'), onPressed: controller.quitGroup),
            ActionChip(label: const Text('解散群'), onPressed: controller.dismissGroup),
          ],
        ),
        const SizedBox(height: 16),
        const Text('群成员', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() {
          return Column(
            children: controller.members.map((m) {
              return ListTile(
                title: Text(m.nickname ?? m.userID ?? ''),
                subtitle: Text(m.userID ?? ''),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

class _DangerZoneSection extends StatelessWidget {
  const _DangerZoneSection(this.controller, {required this.confirm});
  final ChatDetailLogic controller;
  final Future<bool?> Function(BuildContext, String) confirm;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '危险操作',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!controller.isGroup)
              ActionChip(
                label: const Text('删除好友'),
                onPressed: () async {
                  final ok = await confirm(context, '确认删除该好友?');
                  if (ok == true) await controller.deleteFriend();
                },
              ),
            if (controller.isGroup)
              ActionChip(
                label: const Text('解散群'),
                onPressed: () async {
                  final ok = await confirm(context, '确认解散该群?');
                  if (ok == true) await controller.dismissGroup();
                },
              ),
          ],
        ),
      ],
    );
  }
}
