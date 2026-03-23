import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class StatCard extends StatelessWidget {
  final String value, label;
  final bool isSmall;
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = isSmall ? 12.0 : 24.0;
    final valueFontSize = isSmall ? 18.0 : 22.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: padding * 0.583,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyan,
                  shadows: const [
                    Shadow(color: AppColors.cyan, blurRadius: 12),
                  ],
                ),
              ),
              SizedBox(height: isSmall ? 2 : 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  letterSpacing: 2,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
