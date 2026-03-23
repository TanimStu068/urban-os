import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class ScanBeam extends StatelessWidget {
  final Animation<double> animation;
  final double height;
  const ScanBeam({super.key, required this.animation, required this.height});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final y = animation.value * height;
        return Positioned(
          top: y - 1,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.cyan.withOpacity(0.06),
                  AppColors.cyan.withOpacity(0.12),
                  AppColors.cyan.withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
