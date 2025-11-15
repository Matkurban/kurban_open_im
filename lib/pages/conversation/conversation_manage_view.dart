import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'conversation_manage_logic.dart';

class ConversationManageView extends GetView<ConversationManageLogic> {
  const ConversationManageView({super.key});

  @override
  Widget build(BuildContext context) {
    final idCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('会话管理')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextField(controller: idCtrl, decoration: const InputDecoration(labelText: '会话ID'))),
              const SizedBox(width: 8),
              FilledButton(onPressed: () => controller.hide(idCtrl.text.trim()), child: const Text('隐藏')),
            ]),
          ],
        ),
      ),
    );
  }
}