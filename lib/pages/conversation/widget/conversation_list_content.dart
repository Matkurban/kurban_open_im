import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_action_menu.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_empty_placeholder.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_list_item.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/widgets/app_dialog.dart';

class ConversationListContent extends StatelessWidget {
  const ConversationListContent({super.key, required this.logic});

  final ConversationLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conversations = logic.filteredConversationList;
      if (conversations.isEmpty) {
        return ConversationEmptyPlaceholder(logic: logic);
      }
      return RefreshIndicator(
        onRefresh: logic.getConversationList,
        child: ListView.builder(
          controller: logic.scrollController,
          itemCount: conversations.length,
          itemBuilder: (BuildContext context, int index) {
            final conversation = conversations[index];
            return Slidable(
              key: ValueKey(conversation.conversationID),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _togglePinned(conversation),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    icon: conversation.isPinned == true ? Icons.push_pin_outlined : Icons.push_pin,
                    label: conversation.isPinned == true ? '取消置顶' : '置顶',
                  ),
                  SlidableAction(
                    onPressed: (_) => _confirmDelete(context, conversation),
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                    icon: Icons.delete_outline,
                    label: '删除',
                  ),
                ],
              ),
              child: ConversationListItem(
                conversation: conversation,
                onTap: () {
                  Get.toNamed(RouterName.chat, arguments: conversation);
                },
                onLongPress: (position) => _showContextMenu(context, position, conversation),
              ),
            );
          },
        ),
      );
    });
  }

  void _togglePinned(ConversationInfo conversation) {
    logic.setPinned(conversation.conversationID, !(conversation.isPinned ?? false));
  }

  Future<void> _showContextMenu(
    BuildContext context,
    Offset position,
    ConversationInfo conversation,
  ) async {
    final action = await ConversationContextMenu.show(
      context: context,
      position: position,
      conversation: conversation,
    );

    switch (action) {
      case ConversationContextMenuAction.markAsRead:
        await logic.markConversationMessageAsRead(conversation.conversationID);
        break;
      case ConversationContextMenuAction.recvOptRemind:
        await logic.setRecvMsgOpt(conversationID: conversation.conversationID, recvMsgOpt: 0);
        break;
      case ConversationContextMenuAction.recvOptSilent:
        await logic.setRecvMsgOpt(conversationID: conversation.conversationID, recvMsgOpt: 1);
        break;
      case ConversationContextMenuAction.recvOptReject:
        await logic.setRecvMsgOpt(conversationID: conversation.conversationID, recvMsgOpt: 2);
        break;
      case ConversationContextMenuAction.clearMessages:
        if (context.mounted) {
          _confirmClear(context, conversation);
        }
        break;
      case null:
        break;
    }
  }

  void _confirmDelete(BuildContext context, ConversationInfo conversation) {
    AppDialog.tipDialog(
      title: '删除会话',
      content: '确定要删除该会话及其所有聊天记录吗？',
      onConfirm: () => logic.deleteConversation(conversation.conversationID),
    );
  }

  void _confirmClear(BuildContext context, ConversationInfo conversation) {
    AppDialog.tipDialog(
      title: '清空聊天记录',
      content: '确定要清空该会话的所有聊天记录吗？',
      onConfirm: () => logic.clearConversationAndDeleteAllMsg(conversation.conversationID),
    );
  }
}
