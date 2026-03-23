import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class Req extends StatelessWidget {
  final bool met;
  final String label;
  const Req({required this.met, required this.label, super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        met ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: met ? AppColors.success : AppColors.muted,
        size: 10,
      ),
      const SizedBox(width: 3),
      Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          letterSpacing: .5,
          color: met ? AppColors.success : AppColors.muted,
        ),
      ),
    ],
  );
}
