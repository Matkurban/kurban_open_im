import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/conversation/widget/conversation_list_item.dart';
import 'package:kurban_open_im/router/router_name.dart';

class ConversationView extends GetView<ConversationLogic> {
  const ConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
        actions: [
          IconButton(onPressed: () => Get.toNamed('/conversation_manage'), icon: const Icon(Icons.settings)),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.conversationList.length,
          itemBuilder: (BuildContext context, int index) {
            var conversationInfo = controller.conversationList[index];
            return InkWell(
              onTap: () {
                final isGroup = (conversationInfo.groupID?.isNotEmpty ?? false);
                final recvID = conversationInfo.userID;
                final groupID = conversationInfo.groupID;
                Get.toNamed(
                  RouterName.chat,
                  arguments: {
                    "isGroup": isGroup,
                    "recvID": recvID,
                    "groupID": groupID,
                    "title": conversationInfo.showName,
                  },
                );
              },
              child: ConversationListItem(conversation: conversationInfo),
            );
          },
        );
      }),
    );
  }
}
