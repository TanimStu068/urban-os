import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class SLabel extends StatelessWidget {
  final String main;
  final String? sub;
  const SLabel(this.main, this.sub, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          main,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: AppColors.mutedLt,
            letterSpacing: 1.5,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.bgCard2,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              sub!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                color: AppColors.mutedLt,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
