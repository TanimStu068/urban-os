import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

class HexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final config in [
      [AppColors.cyan.withOpacity(0.2), 24.0],
      [AppColors.cyan.withOpacity(0.1), 16.0],
    ]) {
      final paint = Paint()
        ..color = config[0] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final r = config[1] as double;
      final path = Path();
      for (int i = 0; i < 6; i++) {
        final angle = (i * 60 - 30) * pi / 180;
        final x = size.width / 2 + r * cos(angle);
        final y = size.height / 2 + r * sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
