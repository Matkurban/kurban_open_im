import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatLocationResult {
  const ChatLocationResult({required this.title, required this.latitude, required this.longitude});

  final String title;
  final double latitude;
  final double longitude;
}

class ChatLocationPickerDialog extends StatefulWidget {
  const ChatLocationPickerDialog({super.key});

  static Future<ChatLocationResult?> show(BuildContext context) {
    return showDialog<ChatLocationResult>(
      context: context,
      builder: (context) => const ChatLocationPickerDialog(),
    );
  }

  @override
  State<ChatLocationPickerDialog> createState() => _ChatLocationPickerDialogState();
}

class _ChatLocationPickerDialogState extends State<ChatLocationPickerDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String? _latitudeError;
  String? _longitudeError;

  @override
  void dispose() {
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _latitudeError = null;
      _longitudeError = null;
    });
    final title = _titleController.text.trim();
    final latitude = double.tryParse(_latitudeController.text.trim());
    final longitude = double.tryParse(_longitudeController.text.trim());
    if (latitude == null) {
      setState(() => _latitudeError = "请输入正确的纬度");
      return;
    }
    if (longitude == null) {
      setState(() => _longitudeError = "请输入正确的经度");
      return;
    }
    Navigator.of(context).pop(
      ChatLocationResult(
        title: title.isEmpty ? "位置" : title,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("发送位置"),
      content: SizedBox(
        width: 320.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "位置描述", hintText: "例如 公司、家"),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _latitudeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(labelText: "纬度", errorText: _latitudeError),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _longitudeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(labelText: "经度", errorText: _longitudeError),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("取消")),
        FilledButton(onPressed: _submit, child: const Text("发送")),
      ],
    );
  }
}
