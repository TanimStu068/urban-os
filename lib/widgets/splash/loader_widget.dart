import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class LoaderWidget extends StatelessWidget {
  final double pct;
  final String label, message;
  final int step, total;
  final bool isSmallScreen;
  const LoaderWidget({
    super.key,
    required this.pct,
    required this.label,
    required this.message,
    required this.step,
    required this.total,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = isSmallScreen ? 260.0 : 320.0;

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: AppColors.muted,
                ),
              ),
              Text(
                '${(pct * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Track
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(height: 2, color: AppColors.cyan.withOpacity(0.1)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  width: 320 * pct,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.cyanDim,
                        AppColors.cyan,
                        AppColors.teal,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.cyan, blurRadius: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Step dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < step ? AppColors.cyan : AppColors.muted,
                  boxShadow: i < step
                      ? [BoxShadow(color: AppColors.cyan, blurRadius: 6)]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              message,
              key: ValueKey(message),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                letterSpacing: 1,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
