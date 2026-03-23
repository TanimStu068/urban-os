import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class HexLogo extends StatelessWidget {
  final AnimationController orbitCtrl;
  const HexLogo({super.key, required this.orbitCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orbitCtrl,
      builder: (_, __) => SizedBox(
        width: 42,
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: orbitCtrl.value * 2 * pi,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.cyan.withOpacity(0.2), width: 1),
                ),
              ),
            ),
            Transform.rotate(
              angle: -orbitCtrl.value * 2 * pi * 0.6,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _C.amber.withOpacity(0.25),
                    width: 0.8,
                  ),
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _C.cyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _C.cyan.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: _C.cyan.withOpacity(0.3), blurRadius: 8),
                ],
              ),
              child: const Icon(
                Icons.hexagon_outlined,
                color: _C.cyan,
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
