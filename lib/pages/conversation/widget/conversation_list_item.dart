import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({super.key, required this.conversation, this.onTap});

  final ConversationInfo conversation;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    final latest = conversation.latestMsg;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
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
            ],
          ),
        ),
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
