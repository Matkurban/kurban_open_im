import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_list_item.dart';

class ConversationView extends GetView<ConversationLogic> {
  const ConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("消息")),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.conversationList.length,
          itemBuilder: (BuildContext context, int index) {
            var conversationInfo = controller.conversationList[index];
            return ConversationListItem(conversation: conversationInfo);
          },
        );
      }),
    );
  }
}
