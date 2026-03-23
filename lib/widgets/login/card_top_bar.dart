import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CardTopBar extends StatelessWidget {
  const CardTopBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.04),
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.teal, blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: const Text(
              'AUTH TERMINAL — SECURE SESSION',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 2,
                color: AppColors.muted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'AES-256',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              letterSpacing: 1.5,
              color: AppColors.cyanDim,
            ),
          ),
        ],
      ),
    );
  }
}
