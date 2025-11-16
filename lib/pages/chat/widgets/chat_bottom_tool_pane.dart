import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';

class ChatBottomToolPane extends GetWidget<ChatLogic> {
  const ChatBottomToolPane({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: GridView(
        padding: EdgeInsets.all(20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20.w,
          crossAxisSpacing: 20.w,
        ),
        children: [
          ChatBottomToolItem(
            label: "相册",
            icon: Icons.photo_album,
            labelStyle: theme.textTheme.bodySmall,
            cardColor: theme.colorScheme.tertiaryFixed,
            onTap: controller.selectImage,
          ),
          ChatBottomToolItem(
            label: "拍摄",
            labelStyle: theme.textTheme.bodySmall,
            icon: Icons.camera_alt,
            cardColor: theme.colorScheme.tertiaryFixed,
          ),
          ChatBottomToolItem(
            label: "视频通话",
            labelStyle: theme.textTheme.bodySmall,
            icon: Icons.video_chat,
            cardColor: theme.colorScheme.tertiaryFixed,
          ),
          ChatBottomToolItem(
            label: "位置",
            labelStyle: theme.textTheme.bodySmall,
            icon: Icons.location_on,
            cardColor: theme.colorScheme.tertiaryFixed,
          ),
          ChatBottomToolItem(
            label: "文件",
            labelStyle: theme.textTheme.bodySmall,
            icon: Icons.file_copy,
            cardColor: theme.colorScheme.tertiaryFixed,
          ),

          ChatBottomToolItem(
            label: "个人名片",
            labelStyle: theme.textTheme.bodySmall,
            icon: Icons.person,
            cardColor: theme.colorScheme.tertiaryFixed,
          ),
        ],
      ),
    );
  }
}

class ChatBottomToolItem extends StatelessWidget {
  const ChatBottomToolItem({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.cardColor,
    this.labelStyle,
  });

  final String label;

  final TextStyle? labelStyle;

  final IconData icon;

  final Color? cardColor;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyle.defaultRadius,
        child: Column(
          spacing: 4.h,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Icon(icon),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
