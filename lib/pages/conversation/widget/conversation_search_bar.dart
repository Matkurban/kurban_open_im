import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';

class ConversationSearchBar extends StatelessWidget {
  const ConversationSearchBar({super.key, required this.logic});

  final ConversationLogic logic;

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: theme.colorScheme.surface,
      child: Obx(
        () => TextField(
          onChanged: logic.updateSearchKeyword,
          decoration: InputDecoration(
            hintText: '搜索会话',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: logic.searchKeyword.value.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear), onPressed: logic.clearSearch)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
        ),
      ),
    );
  }
}
