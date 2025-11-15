import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_input_bar.dart';
import 'package:kurban_open_im/pages/chat/widgets/message_item.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_action_panel.dart';
import 'package:kurban_open_im/pages/chat/search/message_search_page.dart';

class ChatView extends GetView<ChatLogic> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.title), actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            Get.toNamed(
              RouterName.chatDetail,
              arguments: {
                "isGroup": controller.isGroup,
                "recvID": controller.recvID,
                "groupID": controller.groupID,
                "title": controller.title,
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Get.to(() => const MessageSearchPage(), arguments: {"conversationID": controller.conversationID});
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => const SafeArea(child: SizedBox(height: 300, child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(8), child: ChatActionPanel())))),
            );
          },
        ),
      ]),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return MessageItem(
                    message: msg,
                    onLongPress: () async {
                      final action = await showModalBottomSheet<String>(
                        context: context,
                        builder: (ctx) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(title: const Text('撤回'), onTap: () => Navigator.pop(ctx, 'revoke')),
                                ListTile(title: const Text('删除本地'), onTap: () => Navigator.pop(ctx, 'delete_local')),
                                ListTile(title: const Text('转发'), onTap: () => Navigator.pop(ctx, 'forward')),
                                ListTile(title: const Text('引用'), onTap: () => Navigator.pop(ctx, 'quote')),
                                ListTile(title: const Text('合并最近消息'), onTap: () => Navigator.pop(ctx, 'merge_recent')),
                              ],
                            ),
                          );
                        },
                      );
                      if (action == 'revoke') {
                        await controller.revoke(msg);
                      } else if (action == 'delete_local') {
                        await controller.deleteLocal(msg);
                      } else if (action == 'forward') {
                        await controller.forward(msg);
                      } else if (action == 'quote') {
                        final text = await showDialog<String>(
                          context: context,
                          builder: (_) {
                            final ctrl = TextEditingController();
                            return AlertDialog(
                              title: const Text('输入引用文本'),
                              content: TextField(controller: ctrl),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
                                TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('确定')),
                              ],
                            );
                          },
                        );
                        if (text != null && text.isNotEmpty) {
                          await controller.sendQuote(msg, text);
                        }
                      } else if (action == 'merge_recent') {
                        final toMerge = controller.messages.take(5).toList();
                        await controller.sendMerger(toMerge);
                      }
                    },
                  );
                },
              );
            }),
          ),
          ChatInputBar(
            controller: controller.inputController,
            onSend: controller.sendText,
            onChanged: controller.onInputChanged,
          ),
        ],
      ),
    );
  }
}
