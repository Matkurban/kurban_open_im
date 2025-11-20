import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/detail/conversation_detail_logic.dart';
import 'package:kurban_open_im/pages/conversation/detail/widget/conversation_detail_header.dart';
import 'package:kurban_open_im/pages/conversation/detail/widget/conversation_detail_setting_tile.dart';
import 'package:kurban_open_im/pages/conversation/detail/widget/conversation_member_preview.dart';
import 'package:kurban_open_im/pages/conversation/detail/widget/conversation_recv_option_dialog.dart';
import 'package:kurban_open_im/widgets/app_dialog.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ConversationDetailView extends GetView<ConversationDetailLogic> {
  const ConversationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.isGroupChat ? '群聊详情' : '聊天详情')),
      body: Obx(() {
        final pinned = controller.isPinned.value;
        final recvOpt = controller.recvMsgOpt.value;
        final groupInfo = controller.groupInfo.value;
        final userInfo = controller.userInfo.value;
        final memberPreview = controller.memberPreview;

        final subtitle = controller.isGroupChat
            ? '群成员 ${groupInfo?.memberCount ?? memberPreview.length}'
            : (userInfo?.userID ?? controller.conversation.userID ?? '');

        return ListView(
          padding: EdgeInsets.only(bottom: 24.h, top: 16.h),
          children: [
            ConversationDetailHeader(
              avatarUrl: controller.conversation.faceURL,
              title: controller.conversation.showName ?? '',
              subtitle: subtitle,
            ),
            if (controller.isGroupChat && memberPreview.isNotEmpty)
              ConversationMemberPreview(
                members: memberPreview.toList(),
                onViewAll: () => _showGroupMemberDialog(context, memberPreview.toList()),
              ),
            if (controller.isGroupChat && (groupInfo?.notification?.isNotEmpty ?? false))
              ConversationSettingTile(
                title: '群公告',
                subtitle: groupInfo?.notification,
                onTap: () => _showAnnouncement(context, groupInfo?.notification ?? ''),
              ),
            ConversationSettingSwitchTile(
              title: '置顶聊天',
              value: pinned,
              onChanged: (value) => controller.togglePinned(value),
            ),
            ConversationSettingTile(
              title: '消息提醒',
              trailing: Text(_recvOptDesc(recvOpt), style: Theme.of(context).textTheme.bodyMedium),
              onTap: () => _selectRecvOpt(context, recvOpt),
            ),
            ConversationSettingTile(
              title: '清空聊天记录',
              onTap: () => _confirmClear(context),
              trailing: const Icon(Icons.delete_sweep_outlined),
            ),
            ConversationSettingTile(
              title: '删除会话',
              onTap: () => _confirmDelete(context),
              trailing: const Icon(Icons.delete_outline),
            ),
            if (controller.isGroupChat)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _confirmQuitGroup(context),
                  child: const Text('退出群聊'),
                ),
              ),
          ],
        );
      }),
    );
  }

  Future<void> _selectRecvOpt(BuildContext context, int current) async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) => ConversationRecvOptionDialog(initialValue: current),
    );
    if (result != null) {
      controller.updateRecvMsgOpt(result);
    }
  }

  void _confirmClear(BuildContext context) {
    AppDialog.tipDialog(
      title: '清空聊天记录',
      content: '确定要清空该会话的所有聊天记录吗？',
      onConfirm: () => controller.clearChatHistory(),
    );
  }

  void _confirmDelete(BuildContext context) {
    AppDialog.tipDialog(
      title: '删除会话',
      content: '删除后将移除该会话，确认继续吗？',
      onConfirm: () => controller.deleteConversation(),
    );
  }

  void _confirmQuitGroup(BuildContext context) {
    AppDialog.tipDialog(
      title: '退出群聊',
      content: '退出后将不再接收该群的消息，确认退出吗？',
      onConfirm: () => controller.quitGroup(),
    );
  }

  void _showAnnouncement(BuildContext context, String announcement) {
    if (announcement.isEmpty) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('群公告'),
        content: SingleChildScrollView(child: Text(announcement)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('关闭')),
        ],
      ),
    );
  }

  void _showGroupMemberDialog(BuildContext context, List<GroupMembersInfo> members) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('群成员'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                leading: AvatarView(url: member.faceURL, name: member.nickname ?? member.userID),
                title: Text(member.nickname ?? member.userID ?? ''),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('关闭')),
        ],
      ),
    );
  }

  String _recvOptDesc(int opt) {
    switch (opt) {
      case 0:
        return '接收消息并提醒';
      case 1:
        return '接收消息不提醒';
      case 2:
        return '不接收消息';
      default:
        return '未知状态';
    }
  }
}
