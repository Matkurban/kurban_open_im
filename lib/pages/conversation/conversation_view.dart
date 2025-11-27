import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/connect_status_widget.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_list_content.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_search_bar.dart';

class ConversationView extends GetView<ConversationLogic> {
  const ConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const ConnectStatusWidget(),
        leadingWidth: 100.w,
        title: const Text("消息"),
        actions: [
          Obx(() {
            final total = controller.totalUnreadCount.value;
            if (total <= 0) {
              return const SizedBox.shrink();
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '未读: $total',
                  style: TextStyle(fontSize: 14.sp, color: theme.colorScheme.primary),
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          ConversationSearchBar(logic: controller),
          Expanded(child: ConversationListContent(logic: controller)),
        ],
      ),
    );
  }
}
