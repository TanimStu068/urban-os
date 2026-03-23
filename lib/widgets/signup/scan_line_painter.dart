import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = Colors.black.withOpacity(.05);
    for (double y = 0; y < s.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y + 3, s.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
