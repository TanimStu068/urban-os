import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BottomItem extends StatelessWidget {
  final String text;
  const BottomItem(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 9,
        letterSpacing: 2,
        color: AppColors.muted,
      ),
    );
  }
}
