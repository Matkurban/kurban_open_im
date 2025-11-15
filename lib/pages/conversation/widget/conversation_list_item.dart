import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({super.key, required this.conversation});

  final ConversationInfo conversation;

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        spacing: 8.w,
        children: [
          AvatarView(url: conversation.faceURL, name: conversation.showName),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(conversation.showName ?? "", style: theme.textTheme.titleMedium),
                if (conversation.latestMsg != null)
                  Row(
                    spacing: 16.w,
                    children: [
                      Expanded(
                        child: Text(
                          getMessageLastContent(conversation.latestMsg!),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        formatTimestamp(
                          conversation.latestMsg!.sendTime ??
                              conversation.latestMsg!.createTime ??
                              0,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getMessageLastContent(Message message) {
    switch (message.contentType) {
      case MessageType.text:
        return message.textElem!.content ?? "";
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
