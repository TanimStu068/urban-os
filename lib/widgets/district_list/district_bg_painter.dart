import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class DistrictBgPainter extends CustomPainter {
  final double t;
  DistrictBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    final gp = Paint()
      ..color = AppColors.cyan.withOpacity(0.028)
      ..strokeWidth = 0.4;
    const sp = 30.0;
    for (double x = 0; x < s.width; x += sp) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    }
    for (double y = 0; y < s.height; y += sp) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);
    }
    // Soft radial ambience
    canvas.drawCircle(
      Offset(s.width * 0.8, s.height * 0.15),
      200,
      Paint()
        ..color = AppColors.violet.withOpacity(0.025)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90),
    );
    canvas.drawCircle(
      Offset(s.width * 0.15, s.height * 0.7),
      160,
      Paint()
        ..color = AppColors.cyan.withOpacity(0.02)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  @override
  bool shouldRepaint(DistrictBgPainter old) => false;
}
