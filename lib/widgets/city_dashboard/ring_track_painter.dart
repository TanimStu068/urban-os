import 'package:flutter/material.dart';

class RingTrackPainter extends CustomPainter {
  final Color color;
  RingTrackPainter(this.color);
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.width / 2 - 6,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
