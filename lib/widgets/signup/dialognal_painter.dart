import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = AppColors.cyan.withOpacity(.025)
      ..strokeWidth = .8;
    for (int i = -5; i < 20; i++) {
      final x = i * s.width / 8;
      canvas.drawLine(Offset(x, 0), Offset(x + s.height * .3, s.height), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
