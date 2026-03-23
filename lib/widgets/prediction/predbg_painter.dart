import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PredBgPainter extends CustomPainter {
  final double t, scan, glow;
  PredBgPainter(this.t, this.scan, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.violet.withOpacity(0.025)
      ..strokeWidth = 0.5;
    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    // Radial glow top
    final radPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.violet.withOpacity(0.06 + glow * 0.03),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, -20),
              radius: size.height * 0.6,
            ),
          );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), radPaint);

    // Scan
    final sy = (scan * size.height * 1.1) - size.height * 0.05;
    final sp = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.cyan.withOpacity(0.03),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, sy - 30, size.width, 60));
    canvas.drawRect(Rect.fromLTWH(0, sy - 30, size.width, 60), sp);
  }

  @override
  bool shouldRepaint(PredBgPainter old) => old.scan != scan || old.glow != glow;
}
