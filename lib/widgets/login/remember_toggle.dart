import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class RememberToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const RememberToggle({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.cyan.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: value ? AppColors.cyan : AppColors.muted,
                width: 1,
              ),
            ),
            child: value
                ? const Icon(Icons.check, color: AppColors.cyan, size: 11)
                : null,
          ),
          const SizedBox(width: 8),
          const Text(
            'REMEMBER SESSION',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 1.5,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
