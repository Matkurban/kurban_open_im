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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OptionTile(title: '接收消息并提醒', value: 0, groupValue: selectedValue, onChanged: _onChanged),
          _OptionTile(title: '接收消息不提醒', value: 1, groupValue: selectedValue, onChanged: _onChanged),
          _OptionTile(title: '不接收消息', value: 2, groupValue: selectedValue, onChanged: _onChanged),
        ],
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

  void _onChanged(int value) {
    setState(() {
      selectedValue = value;
    });
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onChanged(value),
      leading: Radio<int>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) {
            onChanged(val);
          }
        },
      ),
      title: Text(title),
    );
  }
}
