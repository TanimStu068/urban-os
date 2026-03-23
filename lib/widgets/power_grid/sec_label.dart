import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SecLabel extends StatelessWidget {
  final String text;
  const SecLabel(this.text, {super.key});
  @override
  Widget build(BuildContext ctx) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'monospace',
      fontSize: 7.5,
      color: C.muted,
      letterSpacing: 1,
    ),
  );
}
