import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_input_bar.dart';
import 'package:kurban_open_im/pages/chat/widgets/message_item.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ChatView extends GetView<ChatLogic> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = context.getSize;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(controller.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () async {
              final result = await Get.toNamed(
                RouterName.conversationDetail,
                arguments: controller.conversation,
              );
              if (result == true && Get.key.currentState?.canPop() == true) {
                Get.back<void>();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                controller: controller.scrollController,
                cacheExtent: size.height * 3,
                physics: ChatObserverClampingScrollPhysics(observer: controller.chatScrollObserver),
                shrinkWrap: controller.chatScrollObserver.isShrinkWrap,
                itemCount: controller.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final msg = controller.indexOfMessage(index);
                  final clientID = msg.clientMsgID;
                  final key = clientID != null
                      ? ValueKey(clientID)
                      : ValueKey('${msg.hashCode}_$index');
                  return MessageItem(key: key, message: msg);
                },
              );
            }),
          ),
          const ChatInputBar(),
        ],
      ),
    );
  }
}
