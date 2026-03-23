import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

class GridPainter extends CustomPainter {
  final double t;
  const GridPainter(this.t);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = AppColors.cyan.withOpacity(
        .022 * (0.5 + (sin(t * pi) + 1) / 2 * .3),
      )
      ..strokeWidth = .5;
    for (double x = 0; x < s.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
  }

  @override
  bool shouldRepaint(GridPainter o) => o.t != t;
}
