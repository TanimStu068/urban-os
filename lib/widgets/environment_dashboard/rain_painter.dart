import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class RainPainter extends CustomPainter {
  final double t, intensity;
  const RainPainter({required this.t, required this.intensity});

  @override
  void paint(Canvas canvas, Size s) {
    final rng = Random(42);
    final drops = (40 * intensity).toInt();
    for (int i = 0; i < drops; i++) {
      final x = rng.nextDouble() * s.width;
      final y = ((t + rng.nextDouble()) % 1.0) * s.height;
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y + 12),
        Paint()
          ..color = C.sky.withOpacity(0.12 + rng.nextDouble() * 0.08)
          ..strokeWidth = 0.8
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(RainPainter o) => o.t != t;
}
