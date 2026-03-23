import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class GridBgPainter extends CustomPainter {
  final double t;
  final double scan;
  GridBgPainter(this.t, this.scan);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.03)
      ..strokeWidth = 0.5;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    // Scan beam
    final sy = (scan * size.height * 1.2) - size.height * 0.1;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.violet.withOpacity(0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, sy - 40, size.width, 80));
    canvas.drawRect(Rect.fromLTWH(0, sy - 40, size.width, 80), scanPaint);
  }

  @override
  bool shouldRepaint(GridBgPainter old) => old.t != t || old.scan != scan;
}
