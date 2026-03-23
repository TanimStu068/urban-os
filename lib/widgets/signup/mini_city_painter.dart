import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class MiniCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(
      const Rect.fromLTWH(1, 12, 4, 12),
      p..color = AppColors.cyan,
    );
    canvas.drawRect(
      const Rect.fromLTWH(7, 8, 5, 16),
      p..color = AppColors.cyan,
    );
    canvas.drawRect(
      const Rect.fromLTWH(14, 3, 7, 21),
      p
        ..color = AppColors.teal
        ..strokeWidth = 1.2,
    );
    canvas.drawRect(
      const Rect.fromLTWH(23, 9, 4, 15),
      p
        ..color = AppColors.cyan
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      const Offset(17.5, 3),
      const Offset(17.5, 0),
      p
        ..color = AppColors.cyan
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      const Offset(17.5, 0),
      1.2,
      Paint()..color = AppColors.cyan,
    );
    canvas.drawLine(
      const Offset(0, 24),
      Offset(s.width, 24),
      Paint()
        ..color = AppColors.cyan.withOpacity(.3)
        ..strokeWidth = .8,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
