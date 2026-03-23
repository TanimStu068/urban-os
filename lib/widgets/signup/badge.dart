import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  const BadgeWidget(this.icon, this.label, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.glassBdr),
      color: AppColors.glassBg,
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 9),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            letterSpacing: 1,
            color: AppColors.muted,
          ),
        ),
      ],
    ),
  );
}
