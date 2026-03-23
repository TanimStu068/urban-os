import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class GridPainter extends CustomPainter {
  final double t;
  const GridPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final op = 0.5 + (sin(t * pi) + 1) / 2 * 0.3;
    final p = Paint()
      ..color = AppColors.cyan.withOpacity(0.025 * op)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(GridPainter o) => o.t != t;
}
