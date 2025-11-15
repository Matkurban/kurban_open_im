import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_create_logic.dart';

class GroupCreateView extends GetView<GroupCreateLogic> {
  const GroupCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final memberCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('创建群组')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '群名称')),
            const SizedBox(height: 12),
            TextField(controller: memberCtrl, decoration: const InputDecoration(labelText: '成员ID，逗号分隔')),
            const SizedBox(height: 20),
            Obx(() {
              return FilledButton(
                onPressed: controller.creating.value
                    ? null
                    : () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        final members = memberCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                        await controller.create(name: name, memberIDs: members);
                        if (context.mounted) Navigator.pop(context);
                      },
                child: Text(controller.creating.value ? '创建中' : '创建'),
              );
            }),
          ],
        ),
      ),
    );
  }
}