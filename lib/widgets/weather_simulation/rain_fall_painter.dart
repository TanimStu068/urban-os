import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class RainfallPainter extends CustomPainter {
  final double t;
  final double intensity;

  RainfallPainter({required this.t, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = C.cyan.withOpacity(0.04 * intensity)
      ..strokeWidth = 1;

    final random = Random(42);
    for (int i = 0; i < 20; i++) {
      final x = (random.nextDouble() * size.width) % size.width;
      final y =
          ((random.nextDouble() * size.height + t * size.height) % size.height);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(RainfallPainter oldDelegate) => t != oldDelegate.t;
}
