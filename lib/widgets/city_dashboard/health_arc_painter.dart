import 'package:flutter/material.dart';
import 'dart:math';

class HealthArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  HealthArcPainter(this.progress, this.color);
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2 - 6;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      progress * 2 * pi,
      false,
      Paint()
        ..shader = SweepGradient(
          transform: const GradientRotation(-pi / 2),
          colors: [color.withOpacity(.6), color],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      progress * 2 * pi,
      false,
      Paint()
        ..color = color.withOpacity(.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(HealthArcPainter o) =>
      o.progress != progress || o.color != color;
}
