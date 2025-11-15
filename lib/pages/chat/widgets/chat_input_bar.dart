import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/extension/context_extension.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.controller, required this.onSend, this.onChanged});

  ///输入框控制器
  final TextEditingController controller;

  ///发送回调
  final VoidCallback onSend;

  ///输入变更回调
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: AppStyle.defaultRadius),
      child: Row(
        children: [
          Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "输入消息", border: InputBorder.none),
            minLines: 1,
            maxLines: 4,
            onChanged: onChanged,
          ),
          ),
          SizedBox(width: 8.w),
          FilledButton(onPressed: onSend, child: const Text("发送")),
        ],
      ),
    );
  }
}