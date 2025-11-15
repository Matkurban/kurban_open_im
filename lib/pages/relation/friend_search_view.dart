import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'friend_search_logic.dart';

class FriendSearchView extends GetView<FriendSearchLogic> {
  const FriendSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final keyCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('搜索好友')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: keyCtrl, decoration: const InputDecoration(labelText: '关键字'))),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    await controller.search(keyCtrl.text.trim());
                  },
                  child: const Text('搜索'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.results.length,
                itemBuilder: (context, index) {
                  final u = controller.results[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Text('U')),
                    title: Text(u['showName'] ?? ''),
                    subtitle: Text(u['userID'] ?? ''),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}