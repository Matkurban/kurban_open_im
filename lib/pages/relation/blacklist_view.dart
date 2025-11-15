import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'blacklist_logic.dart';

class BlacklistView extends GetView<BlacklistLogic> {
  const BlacklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('黑名单')),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            final b = controller.list[index];
            return ListTile(
              leading: const CircleAvatar(child: Text('B')),
              title: Text(b['nickname'] ?? ''),
              subtitle: Text(b['userID'] ?? ''),
              trailing: OutlinedButton(
                onPressed: () => controller.remove(b['userID'] ?? ''),
                child: const Text('移除'),
              ),
            );
          },
        );
      }),
    );
  }
}