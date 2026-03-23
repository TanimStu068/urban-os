import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class ReportBgPainter extends CustomPainter {
  final double t, scan, glow;
  ReportBgPainter(this.t, this.scan, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final gp = Paint()
      ..color = AppColors.green.withOpacity(0.02)
      ..strokeWidth = 0.5;
    const sp = 30.0;
    for (double x = 0; x < size.width; x += sp) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gp);
    }
    for (double y = 0; y < size.height; y += sp) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gp);
    }
    final radP = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.green.withOpacity(0.04 + glow * 0.02),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.3),
              radius: size.height * 0.5,
            ),
          );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), radP);

    final sy = (scan * size.height * 1.1) - size.height * 0.05;
    final sp2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.green.withOpacity(0.025),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, sy - 30, size.width, 60));
    canvas.drawRect(Rect.fromLTWH(0, sy - 30, size.width, 60), sp2);
  }

  @override
  bool shouldRepaint(ReportBgPainter old) =>
      old.scan != scan || old.glow != glow;
}
