import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CenterGlow extends StatelessWidget {
  final Animation<double> animation;
  const CenterGlow({super.key, required this.animation});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (_, __) => Positioned.fill(
      child: Center(
        child: Transform.scale(
          scale: 1.0 + animation.value * 0.12,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.cyan.withOpacity(0.05 + animation.value * 0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
