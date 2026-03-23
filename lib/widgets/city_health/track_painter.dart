import 'package:flutter/material.dart';

class TrackPainter extends CustomPainter {
  final Color c;
  final double d;
  final double sw;
  TrackPainter(this.c, this.d, this.sw);
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      d / 2,
      Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
