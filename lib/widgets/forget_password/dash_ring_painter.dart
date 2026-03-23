import 'package:flutter/material.dart';
import 'dart:math';

class DashRingPainter extends CustomPainter {
  final Color color;
  const DashRingPainter(this.color);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2 - 2;
    for (int i = 0; i < 12; i++) {
      final a = i * pi / 6;
      canvas.drawLine(
        Offset(cx + r * .8 * cos(a), cy + r * .8 * sin(a)),
        Offset(cx + r * cos(a), cy + r * sin(a)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
