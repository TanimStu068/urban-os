import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ScanLine extends StatelessWidget {
  final AnimationController ctrl;
  final double height;
  const ScanLine({super.key, required this.ctrl, required this.height});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => Positioned(
      top: ctrl.value * height,
      left: 0,
      right: 0,
      child: Container(
        height: 1.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              C.teal.withOpacity(.05),
              C.teal.withOpacity(.1),
              C.teal.withOpacity(.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ),
  );
}
