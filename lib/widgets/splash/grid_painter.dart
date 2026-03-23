import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

class GridPainter extends CustomPainter {
  final double t;
  GridPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final opacity = 0.6 + (sin(t * pi) + 1) / 2 * 0.4;
    final paint = Paint()
      ..color = AppColors.cyan.withOpacity(0.03 * opacity)
      ..strokeWidth = 0.5;
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter o) => o.t != t;
}
