import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';

class ChatBottomToolPane extends StatelessWidget {
  const ChatBottomToolPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      width: double.infinity,
      decoration: BoxDecoration(color: context.getTheme.colorScheme.error),
      child: Text('ChatBottomToolPane'),
    );
  }
}
