import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart'; // assuming C is defined here

typedef C = AppColors;

class LoaderDistrictWidget extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const LoaderDistrictWidget({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (_, __) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: C.cyan.withOpacity(0.4 + pulseAnimation.value * 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: C.cyan.withOpacity(0.1 + pulseAnimation.value * 0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: C.cyan,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'LOADING DISTRICTS…',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: C.mutedLt,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
