import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';

class ConversationDraftInput extends StatefulWidget {
  const ConversationDraftInput({
    super.key,
    required this.initialDraft,
    required this.onChanged,
    this.hintText = '设置会话草稿',
  });

  final String? initialDraft;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<ConversationDraftInput> createState() => _ConversationDraftInputState();
}

class _ConversationDraftInputState extends State<ConversationDraftInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDraft ?? '')
      ..addListener(() {
        widget.onChanged(_controller.text);
      });
  }

  @override
  void didUpdateWidget(covariant ConversationDraftInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDraft != widget.initialDraft && widget.initialDraft != _controller.text) {
      _controller.text = widget.initialDraft ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.getTheme;
    return TextField(
      controller: _controller,
      maxLines: 3,
      minLines: 1,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
    );
  }
}
