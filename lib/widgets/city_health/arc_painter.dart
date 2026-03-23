import 'package:flutter/material.dart';
import 'dart:math';

class ArcPainter extends CustomPainter {
  final double prog;
  final Color c;
  final double d, sw, offset;
  ArcPainter(this.prog, this.c, this.d, this.sw, this.offset);
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = d / 2 - offset;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      prog * 2 * pi,
      false,
      Paint()
        ..shader = SweepGradient(
          transform: const GradientRotation(-pi / 2),
          colors: [c.withOpacity(.5), c],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round,
    );
    // glow pass
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      prog * 2 * pi,
      false,
      Paint()
        ..color = c.withOpacity(.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(ArcPainter o) => o.prog != prog || o.c != c;
}
