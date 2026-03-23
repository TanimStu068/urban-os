import 'package:flutter/material.dart';

class RadarSweepPainter extends CustomPainter {
  final Color color;
  RadarSweepPainter(this.color);
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2 - 4;
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = SweepGradient(
          colors: [
            Colors.transparent,
            color.withOpacity(.15),
            Colors.transparent,
          ],
          stops: const [0, .25, .5],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
