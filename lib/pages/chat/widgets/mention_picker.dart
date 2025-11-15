import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';

class MentionPicker extends StatefulWidget {
  const MentionPicker({super.key});

  @override
  State<MentionPicker> createState() => _MentionPickerState();
}

class _MentionPickerState extends State<MentionPicker> {
  final ChatLogic logic = Get.find<ChatLogic>();
  final RxList<GroupMembersInfo> members = <GroupMembersInfo>[].obs;
  final RxSet<String> selected = <String>{}.obs;
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (logic.isGroup && logic.groupID != null) {
      final list = await OpenIM.iMManager.groupManager.getGroupMemberList(groupID: logic.groupID!, filter: 0, offset: 0, count: 50);
      members.assignAll(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(controller: _textCtrl, decoration: const InputDecoration(hintText: '输入文本')),
          ),
          if (logic.isGroup)
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final m = members[index];
                    final uid = m.userID ?? '';
                    final checked = selected.contains(uid);
                    return CheckboxListTile(
                      value: checked,
                      title: Text(m.nickname ?? uid),
                      onChanged: (v) {
                        if (v == true) {
                          selected.add(uid);
                        } else {
                          selected.remove(uid);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消'))),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      final ids = logic.isGroup ? selected.toList() : (logic.recvID != null ? [logic.recvID!] : <String>[]);
                      await logic.sendAt(ids, _textCtrl.text.trim());
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text('发送 @'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}