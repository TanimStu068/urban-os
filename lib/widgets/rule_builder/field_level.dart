import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel(this.label, {super.key});
  @override
  Widget build(BuildContext ctx) => Text(
    label,
    style: const TextStyle(
      fontFamily: 'monospace',
      fontSize: 9,
      color: C.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  );
}
