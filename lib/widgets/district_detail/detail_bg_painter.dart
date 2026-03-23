import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class DetailBgPainter extends CustomPainter {
  final double t;
  DetailBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    final gp = Paint()
      ..color = AppColors.cyan.withOpacity(0.025)
      ..strokeWidth = 0.4;
    const sp = 28.0;
    for (double x = 0; x < s.width; x += sp) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    }
    for (double y = 0; y < s.height; y += sp) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);
    }
    canvas.drawCircle(
      Offset(s.width * 0.9, s.height * 0.1),
      180,
      Paint()
        ..color = AppColors.violet.withOpacity(0.02)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  @override
  bool shouldRepaint(DetailBgPainter old) => false;
}
