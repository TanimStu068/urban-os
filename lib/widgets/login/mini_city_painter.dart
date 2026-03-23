import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class MiniCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    // buildings
    canvas.drawRect(
      const Rect.fromLTWH(2, 14, 5, 14),
      p..color = AppColors.cyan,
    );
    canvas.drawRect(
      const Rect.fromLTWH(9, 9, 6, 19),
      p..color = AppColors.cyan,
    );
    canvas.drawRect(
      const Rect.fromLTWH(17, 4, 8, 24),
      p
        ..color = AppColors.teal
        ..strokeWidth = 1.2,
    );
    canvas.drawRect(
      const Rect.fromLTWH(27, 11, 5, 17),
      p
        ..color = AppColors.cyan
        ..strokeWidth = 1,
    );
    // antenna
    canvas.drawLine(
      const Offset(21, 4),
      const Offset(21, 0),
      p
        ..color = AppColors.cyan
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      const Offset(21, 0),
      1.2,
      Paint()..color = AppColors.cyan,
    );
    // ground
    canvas.drawLine(
      const Offset(0, 28),
      Offset(size.width, 28),
      Paint()
        ..color = AppColors.cyan.withOpacity(0.3)
        ..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
