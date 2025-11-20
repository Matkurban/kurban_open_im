import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

enum ConversationContextMenuAction {
  markAsRead,
  recvOptRemind,
  recvOptSilent,
  recvOptReject,
  clearMessages,
}

class ConversationContextMenu {
  const ConversationContextMenu._();

  static Future<ConversationContextMenuAction?> show({
    required BuildContext context,
    required Offset position,
    required ConversationInfo conversation,
  }) async {
    final overlayState = Overlay.of(context, rootOverlay: true);
    final overlay = overlayState.context.findRenderObject() as RenderBox?;
    if (overlay == null) {
      return null;
    }

    return showMenu<ConversationContextMenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: _buildMenuItems(conversation),
    );
  }

  static List<PopupMenuEntry<ConversationContextMenuAction>> _buildMenuItems(
    ConversationInfo conversation,
  ) {
    final entries = <PopupMenuEntry<ConversationContextMenuAction>>[];

    if (conversation.unreadCount > 0) {
      entries.add(
        const PopupMenuItem<ConversationContextMenuAction>(
          value: ConversationContextMenuAction.markAsRead,
          child: Text('标记为已读'),
        ),
      );
      entries.add(const PopupMenuDivider());
    }

    final currentOpt = conversation.recvMsgOpt ?? 0;

    entries.addAll([
      CheckedPopupMenuItem<ConversationContextMenuAction>(
        value: ConversationContextMenuAction.recvOptRemind,
        checked: currentOpt == 0,
        child: const Text('接收消息并提醒'),
      ),
      CheckedPopupMenuItem<ConversationContextMenuAction>(
        value: ConversationContextMenuAction.recvOptSilent,
        checked: currentOpt == 1,
        child: const Text('接收消息不提醒'),
      ),
      CheckedPopupMenuItem<ConversationContextMenuAction>(
        value: ConversationContextMenuAction.recvOptReject,
        checked: currentOpt == 2,
        child: const Text('不接收消息'),
      ),
    ]);

    entries.add(const PopupMenuDivider());

    entries.add(
      const PopupMenuItem<ConversationContextMenuAction>(
        value: ConversationContextMenuAction.clearMessages,
        child: Text('清空聊天记录'),
      ),
    );

    return entries;
  }
}
