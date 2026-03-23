import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _K = AppColors;

class ScanLine extends StatelessWidget {
  final AnimationController ctrl;
  const ScanLine({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) => Positioned(
        top: h * ctrl.value,
        left: 0,
        right: 0,
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                _K.cyan.withOpacity(0.15),
                _K.cyan.withOpacity(0.3),
                _K.cyan.withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
