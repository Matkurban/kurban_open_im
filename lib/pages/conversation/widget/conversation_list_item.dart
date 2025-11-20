import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';
import 'package:kurban_open_im/widgets/unread_badge.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({super.key, required this.conversation, this.onTap, this.onLongPress});

  final ConversationInfo conversation;
  final VoidCallback? onTap;
  final ValueChanged<Offset>? onLongPress;

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    final latest = conversation.latestMsg;
    final isPinned = conversation.isPinned ?? false;
    final isNotDisturb = conversation.recvMsgOpt == 2;
    final hasUnread = conversation.unreadCount > 0;
    final draftText = conversation.draftText;
    final hasDraft = draftText != null && draftText.isNotEmpty;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isPinned ? theme.colorScheme.surfaceContainerHighest : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: onLongPress != null
            ? (details) => onLongPress?.call(details.globalPosition)
            : null,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AvatarView(url: conversation.faceURL, name: conversation.showName),
                    if (isNotDisturb)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_off,
                            size: 12.sp,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                  ],
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isPinned)
                            Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: Icon(
                                Icons.push_pin,
                                size: 14.sp,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              conversation.showName ?? "",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(8.w),
                          if (latest != null)
                            Text(
                              formatTimestamp(latest.sendTime ?? latest.createTime ?? 0),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                        ],
                      ),
                      Gap(4.h),
                      Row(
                        children: [
                          Expanded(
                            child: hasDraft
                                ? RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '[草稿] ',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: draftText,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    latest != null ? getMessageLastContent(latest) : "",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: hasUnread
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.outline,
                                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          if (hasUnread && !isNotDisturb) ...[
                            Gap(8.w),
                            UnreadBadge(count: conversation.unreadCount),
                          ] else if (isNotDisturb && hasUnread) ...[
                            Gap(8.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
