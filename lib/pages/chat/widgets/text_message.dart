import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.textColor,
    required this.bgColor,
  });

  final Message message;
  final ThemeData theme;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: AppStyle.defaultRadius),
      child: Text(
        message.textElem?.content ?? "",
        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      ),
    );
  }
}
