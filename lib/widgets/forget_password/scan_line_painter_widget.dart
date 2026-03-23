import 'package:flutter/material.dart';

class ScanLinePainterWidget extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = Colors.black.withOpacity(.05);
    for (double y = 0; y < s.height; y += 4) {
      c.drawRect(Rect.fromLTWH(0, y + 3, s.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
