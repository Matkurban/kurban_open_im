import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_input_bar.dart';
import 'package:kurban_open_im/pages/chat/widgets/message_item.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ChatView extends GetView<ChatLogic> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = context.getSize;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(controller.title)),
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
                  return MessageItem(key: ValueKey(msg.clientMsgID!), message: msg);
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
