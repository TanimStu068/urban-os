import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  final Color c;
  RadarPainter(this.c);
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.width / 2 - 2,
      Paint()
        ..shader =
            SweepGradient(
              colors: [
                Colors.transparent,
                c.withOpacity(.12),
                Colors.transparent,
              ],
              stops: const [0, .3, .6],
            ).createShader(
              Rect.fromCircle(
                center: Offset(s.width / 2, s.height / 2),
                radius: s.width / 2 - 2,
              ),
            ),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
