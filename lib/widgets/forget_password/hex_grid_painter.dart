import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

class HexGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.cyan.withOpacity(.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .6;
    const r = 20.0;
    final w = r * 2;
    final h = sqrt(3) * r;
    for (int row = -1; row < (size.height / h).ceil() + 1; row++) {
      for (int col = -1; col < (size.width / w).ceil() + 1; col++) {
        final cx = col * w * .75 + (row.isOdd ? w * .375 : 0);
        final cy = row * h;
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final a = (i * 60 - 30) * pi / 180;
          final x = cx + r * cos(a), y = cy + r * sin(a);
          i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
        }
        path.close();
        canvas.drawPath(path, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
