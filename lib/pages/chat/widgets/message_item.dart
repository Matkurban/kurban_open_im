import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/chat/widgets/image_message.dart';
import 'package:kurban_open_im/pages/chat/widgets/text_message.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    final self = userInfo.value;
    final isMe = message.sendID != null && message.sendID == self.userID;

    final avatar = AvatarView(
      url: isMe ? self.faceURL : message.senderFaceUrl,
      name: isMe ? self.nickname : message.senderNickname,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) avatar,
          if (!isMe) SizedBox(width: 8.w),
          Flexible(
            child: Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: _MessageBubble(message: message, isMe: isMe, theme: theme),
            ),
          ),
          if (isMe) SizedBox(width: 8.w),
          if (isMe) avatar,
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe, required this.theme});

  final Message message;
  final bool isMe;
  final ThemeData theme;

  Color get _bubbleColor => isMe ? theme.primaryColor : theme.cardColor;

  Color get _textColor =>
      isMe ? theme.cardColor : (theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface);

  @override
  Widget build(BuildContext context) {
    switch (message.contentType) {
      case MessageType.text:
        return TextMessage(
          message: message,
          theme: theme,
          textColor: _textColor,
          bgColor: _bubbleColor,
        );
      case MessageType.picture:
        return ClipRRect(
          borderRadius: AppStyle.defaultRadius,
          child: ImageMessage(message: message, isMe: isMe),
        );
      case MessageType.voice:
        return _bubbleWrapper(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.graphic_eq, color: _textColor),
              SizedBox(width: 4.w),
              Text(
                '${message.soundElem?.duration ?? 0}s',
                style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
              ),
            ],
          ),
        );
      case MessageType.video:
        return _bubbleWrapper(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill, color: _textColor),
              SizedBox(width: 4.w),
              Text(
                '${(message.videoElem?.duration ?? 0) ~/ 1000}s',
                style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
              ),
            ],
          ),
        );
      case MessageType.file:
        return _bubbleWrapper(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insert_drive_file, color: _textColor),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  message.fileElem?.fileName ?? '文件',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
                ),
              ),
            ],
          ),
        );
      case MessageType.location:
        return _bubbleWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.locationElem?.description ?? '位置',
                style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
              ),
              SizedBox(height: 4.h),
              Text(
                '${message.locationElem?.longitude ?? 0}, ${message.locationElem?.latitude ?? 0}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      case MessageType.card:
        return _CardMessageBubble(
          theme: theme,
          textColor: _textColor,
          bgColor: _bubbleColor,
          name: message.cardElem?.nickname ?? message.cardElem?.userID,
          identifier: message.cardElem?.userID,
          faceURL: message.cardElem?.faceURL,
        );
      case MessageType.merger:
        final title = message.mergeElem?.title ?? '聊天记录';
        final abstracts = message.mergeElem?.abstractList ?? [];
        return _bubbleWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.titleSmall?.copyWith(color: _textColor)),
              SizedBox(height: 4.h),
              for (final text in abstracts.take(3))
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _textColor.withValues(alpha: 0.9),
                  ),
                ),
            ],
          ),
        );
      case MessageType.quote:
        return _bubbleWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.quoteElem?.text != null)
                Text(
                  message.quoteElem!.text!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _textColor.withValues(alpha: 0.9),
                  ),
                ),
              if (message.quoteElem?.text != null) SizedBox(height: 6.h),
              Text(
                message.textElem?.content ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
              ),
            ],
          ),
        );
      case MessageType.custom:
        final data = message.customElem?.data;
        if (data != null && data.isNotEmpty) {
          try {
            final payload = jsonDecode(data);
            if (payload is Map<String, dynamic> && payload['type'] == 'card') {
              return _CardMessageBubble(
                theme: theme,
                textColor: _textColor,
                bgColor: _bubbleColor,
                name: payload['name'] as String?,
                identifier: (payload['userID'] ?? payload['groupID']) as String?,
                faceURL: payload['faceURL'] as String?,
              );
            }
          } catch (_) {
            // fall through to plain rendering
          }
        }
        return _bubbleWrapper(
          Text(
            message.customElem?.description ?? message.customElem?.data ?? '[自定义消息]',
            style: theme.textTheme.bodyMedium?.copyWith(color: _textColor),
          ),
        );
      default:
        return _bubbleWrapper(
          Text('[暂不支持的消息类型]', style: theme.textTheme.bodyMedium?.copyWith(color: _textColor)),
        );
    }
  }

  Widget _bubbleWrapper(Widget child) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: _bubbleColor, borderRadius: AppStyle.defaultRadius),
      child: child,
    );
  }
}

class _CardMessageBubble extends StatelessWidget {
  const _CardMessageBubble({
    required this.theme,
    required this.textColor,
    required this.bgColor,
    this.name,
    this.identifier,
    this.faceURL,
  });

  final ThemeData theme;
  final Color textColor;
  final Color bgColor;
  final String? name;
  final String? identifier;
  final String? faceURL;

  @override
  Widget build(BuildContext context) {
    final displayName = (name != null && name!.isNotEmpty)
        ? name!
        : (identifier != null && identifier!.isNotEmpty ? identifier! : '名片');
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: bgColor, borderRadius: AppStyle.defaultRadius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarView(url: faceURL, name: displayName, width: 40.w, height: 40.w),
          SizedBox(width: 12.w),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
                if (identifier != null && identifier!.isNotEmpty)
                  Text(
                    identifier!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
