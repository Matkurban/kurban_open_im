import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';

class ConversationEmptyPlaceholder extends StatelessWidget {
  const ConversationEmptyPlaceholder({super.key, required this.logic});

  final ConversationLogic logic;

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    return Obx(() {
      final hasKeyword = logic.searchKeyword.value.isNotEmpty;
      final icon = hasKeyword ? Icons.search_off : Icons.chat_bubble_outline;
      final text = hasKeyword ? '未找到相关会话' : '暂无会话';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64.sp, color: theme.colorScheme.outline),
            SizedBox(height: 16.h),
            Text(
              text,
              style: TextStyle(fontSize: 16.sp, color: theme.colorScheme.outline),
            ),
          ],
        ),
      );
    });
  }
}
