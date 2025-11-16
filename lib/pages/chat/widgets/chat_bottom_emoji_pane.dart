import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/extension/context_extension.dart';

class ChatBottomEmojiPane extends StatelessWidget {
  const ChatBottomEmojiPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      width: double.infinity,
      decoration: BoxDecoration(color: context.getTheme.primaryColor),
      child: Text('ChatBottomEmojiPane'),
    );
  }
}
