import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class MapBgPainter extends CustomPainter {
  final double t;
  MapBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = AppColors.bg);
    final gp = Paint()
      ..color = AppColors.green.withOpacity(0.022)
      ..strokeWidth = 0.5;
    const sp = 24.0;
    for (double x = 0; x < s.width; x += sp) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    }
    for (double y = 0; y < s.height; y += sp) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);
    }
  }

  @override
  bool shouldRepaint(MapBgPainter old) => false;
}
