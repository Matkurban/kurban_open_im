import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/extension/context_extension.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message, this.onLongPress});

  final Message message;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    final isMe = message.sendID == userInfo.value.userID;
    final bgColor = isMe ? theme.primaryColor : theme.cardColor;
    final textColor = isMe ? theme.cardColor : theme.colorScheme.onSurface;
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.7.sw),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(color: bgColor, borderRadius: AppStyle.defaultRadius),
          child: _MessageContent(message: message, theme: theme, textColor: textColor),
        ),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({required this.message, required this.theme, required this.textColor});
  final Message message;
  final ThemeData theme;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    switch (message.contentType) {
      case MessageType.text:
        return Text(message.textElem?.content ?? "", style: theme.textTheme.bodyMedium?.copyWith(color: textColor));
      case MessageType.picture:
        return Text("[图片]", style: theme.textTheme.bodyMedium?.copyWith(color: textColor));
      case MessageType.video:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_circle_fill, color: textColor),
            SizedBox(width: 4.w),
            Text("${(message.videoElem?.duration ?? 0) ~/ 1000}s", style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
          ],
        );
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.graphic_eq, color: textColor),
            SizedBox(width: 4.w),
            Text("${(message.soundElem?.duration ?? 0)}s", style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
          ],
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file, color: textColor),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                message.fileElem?.fileName ?? "文件",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
          ],
        );
      case MessageType.location:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.locationElem?.description ?? "位置", style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
            SizedBox(height: 4.h),
            Text("${message.locationElem?.longitude ?? 0}, ${message.locationElem?.latitude ?? 0}", style: theme.textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.8))),
          ],
        );
      case MessageType.card:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.contact_page, color: textColor),
            SizedBox(width: 6.w),
            Text(message.cardElem?.nickname ?? message.cardElem?.userID ?? "名片", style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
          ],
        );
      case MessageType.merger:
        final title = message.mergeElem?.title ?? "聊天记录";
        final abstracts = message.mergeElem?.abstractList ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(color: textColor)),
            SizedBox(height: 4.h),
            for (final a in abstracts.take(3))
              Text(a, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.9))),
          ],
        );
      case MessageType.quote:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.quoteElem?.text != null)
              Text(
                message.quoteElem!.text!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.9)),
              ),
            SizedBox(height: 6.h),
            Text(message.textElem?.content ?? "", style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
          ],
        );
      case MessageType.custom:
        return Text(message.customElem?.data ?? "[自定义消息]", style: theme.textTheme.bodyMedium?.copyWith(color: textColor));
      default:
        return Text("[暂不支持的消息类型]", style: theme.textTheme.bodyMedium?.copyWith(color: textColor));
    }
  }
}