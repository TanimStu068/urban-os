import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class ScanBeam extends StatelessWidget {
  final Animation<double> anim;
  final double h;
  const ScanBeam({super.key, required this.anim, required this.h});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) => Positioned(
      top: anim.value * h - 1,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.cyan.withOpacity(.05),
              AppColors.cyan.withOpacity(.1),
              AppColors.cyan.withOpacity(.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ),
  );
}
