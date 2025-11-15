import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';

class EmojiPicker extends StatelessWidget {
  const EmojiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ChatLogic>();
    final emojis = [
      (index: 1, data: '😀'),
      (index: 2, data: '😁'),
      (index: 3, data: '😂'),
      (index: 4, data: '😊'),
      (index: 5, data: '😎'),
    ];
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          final e = emojis[index];
          return InkWell(
            onTap: () async {
              await logic.sendEmoji(e.index, e.data);
              Navigator.pop(context);
            },
            child: Center(child: Text(e.data, style: const TextStyle(fontSize: 24))),
          );
        },
      ),
    );
  }
}