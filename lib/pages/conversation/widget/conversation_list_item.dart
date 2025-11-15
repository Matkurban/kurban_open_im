import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({super.key, required this.conversation});

  final ConversationInfo conversation;

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    final latest = conversation.latestMsg;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        spacing: 8.w,
        children: [
          AvatarView(url: conversation.faceURL, name: conversation.showName),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conversation.showName ?? "", style: theme.textTheme.titleMedium),
                if (latest != null)
                  Row(
                    spacing: 16.w,
                    children: [
                      Expanded(
                        child: Text(
                          getMessageLastContent(latest),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        formatTimestamp(latest.sendTime ?? latest.createTime ?? 0),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'pin', child: Text('置顶')),
              PopupMenuItem(value: 'unpin', child: Text('取消置顶')),
              PopupMenuItem(value: 'recv_off', child: Text('设置免打扰')),
              PopupMenuItem(value: 'recv_on', child: Text('取消免打扰')),
            ],
            onSelected: (v) async {
              final logic = Get.find<ConversationLogic>();
              final id = conversation.conversationID;
              if (v == 'pin') {
                await logic.setPinned(id, true);
              } else if (v == 'unpin') {
                await logic.setPinned(id, false);
              } else if (v == 'recv_off') {
                await logic.setRecvOpt(id, 1);
              } else if (v == 'recv_on') {
                await logic.setRecvOpt(id, 0);
              }
            },
          ),
        ],
      ),
    );
  }

  String getMessageLastContent(Message message) {
    switch (message.contentType) {
      case MessageType.text:
        return message.textElem?.content ?? "";
      case MessageType.picture:
        return "[照片]";
      case MessageType.video:
        return "[视频]";
      case MessageType.voice:
        return "[语音]";
      case MessageType.file:
        return "[文件]";
      case MessageType.location:
        return "[位置]";
      case MessageType.card:
        return "[名片]";
      case MessageType.merger:
        return "[聊天记录]";
      default:
        return "";
    }
  }
}
