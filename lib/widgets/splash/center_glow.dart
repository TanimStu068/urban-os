import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CenterGlow extends StatelessWidget {
  final Animation<double> animation;
  const CenterGlow({super.key, required this.animation});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final scale = 1.0 + animation.value * 0.15;
        final opacity = 0.7 + animation.value * 0.3;
        return Positioned.fill(
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withOpacity(0.07 * opacity),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
