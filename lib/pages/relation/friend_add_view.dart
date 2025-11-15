import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'friend_add_logic.dart';

class FriendAddView extends GetView<FriendAddLogic> {
  const FriendAddView({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('添加好友')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: const InputDecoration(labelText: '用户ID')),
            const SizedBox(height: 12),
            TextField(controller: msgCtrl, decoration: const InputDecoration(labelText: '验证消息')),
            const SizedBox(height: 20),
            Obx(() {
              return FilledButton(
                onPressed: controller.submitting.value
                    ? null
                    : () async {
                        final uid = userCtrl.text.trim();
                        if (uid.isEmpty) return;
                        await controller.addFriend(userID: uid, reqMessage: msgCtrl.text.trim());
                        if (context.mounted) Navigator.pop(context);
                      },
                child: Text(controller.submitting.value ? '提交中' : '发送申请'),
              );
            }),
          ],
        ),
      ),
    );
  }
}