import 'package:flutter/material.dart';

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}