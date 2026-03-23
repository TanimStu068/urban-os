import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CheckRow extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final String label;
  const CheckRow({
    super.key,
    required this.value,
    required this.onTap,
    required this.label,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: value ? AppColors.cyan : AppColors.muted),
            color: value ? AppColors.cyan.withOpacity(.15) : Colors.transparent,
          ),
          child: value
              ? const Icon(Icons.check, color: AppColors.cyan, size: 11)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: AppColors.mutedLight,
              letterSpacing: .3,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
