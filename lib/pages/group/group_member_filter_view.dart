import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_member_filter_logic.dart';

class GroupMemberFilterView extends GetView<GroupMemberFilterLogic> {
  const GroupMemberFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final beginCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('成员按入群时间筛选')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: beginCtrl, decoration: const InputDecoration(labelText: '开始时间(秒)'))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: endCtrl, decoration: const InputDecoration(labelText: '结束时间(秒)'))),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final b = int.tryParse(beginCtrl.text.trim()) ?? 0;
                    final e = int.tryParse(endCtrl.text.trim()) ?? 0;
                    await controller.load(startTime: b, endTime: e);
                  },
                  child: const Text('筛选'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.members.length,
                itemBuilder: (context, index) {
                  final m = controller.members[index];
                  return ListTile(
                    title: Text(m.nickname ?? m.userID ?? ''),
                    subtitle: Text('入群时间: ${m.joinTime ?? 0}'),
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