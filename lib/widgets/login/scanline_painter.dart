import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black.withOpacity(0.05);
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y + 3, size.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
