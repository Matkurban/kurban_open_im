import 'package:flutter/material.dart';

class ConversationRecvOptionDialog extends StatefulWidget {
  const ConversationRecvOptionDialog({super.key, required this.initialValue});

  final int initialValue;

  @override
  State<ConversationRecvOptionDialog> createState() => _ConversationRecvOptionDialogState();
}

class _ConversationRecvOptionDialogState extends State<ConversationRecvOptionDialog> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('消息提醒'),
      content: RadioGroup<int>(
        onChanged: _onChanged,
        child: Column(
          children: [
            RadioListTile(value: 0, title: Text("接收消息并提醒")),
            RadioListTile(value: 1, title: Text("接收消息不提醒")),
            RadioListTile(value: 2, title: Text("不接收消息")),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(selectedValue),
          child: const Text('确定'),
        ),
      ],
    );
  }

  void _onChanged(int? value) {
    setState(() {
      selectedValue = value ?? 0;
    });
  }
}
