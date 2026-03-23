import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MonoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool multiline;
  final ValueChanged<String>? onChanged;

  const MonoTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.multiline = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.bgCard2.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: C.gBdr),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: multiline ? 3 : 1,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          color: C.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'monospace',
            color: C.muted,
            fontSize: 10,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
