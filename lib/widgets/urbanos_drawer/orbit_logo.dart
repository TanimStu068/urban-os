import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef _K = AppColors;

class OrbitLogo extends StatelessWidget {
  final AnimationController ctrl;
  const OrbitLogo({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer orbit
          Transform.rotate(
            angle: ctrl.value * 2 * pi,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _K.cyan.withOpacity(0.18), width: 1),
              ),
            ),
          ),
          // Inner orbit (counter-rotating, different speed)
          Transform.rotate(
            angle: -ctrl.value * 2 * pi * 0.7,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _K.amber.withOpacity(0.18),
                  width: 0.8,
                ),
              ),
            ),
          ),
          // Core
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: _K.cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: _K.cyan.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(color: _K.cyan.withOpacity(0.25), blurRadius: 10),
              ],
            ),
            child: const Icon(Icons.hexagon_outlined, color: _K.cyan, size: 14),
          ),
        ],
      ),
    ),
  );
}
