import 'package:flutter/material.dart';
import 'dart:math';

class SimpleArc extends CustomPainter {
  final Color col;
  final double val, glowT;
  SimpleArc(this.col, this.val, this.glowT);
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2 - 4;
    c.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = col.withOpacity(.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    c.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      val * 2 * pi,
      false,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    c.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      val * 2 * pi,
      false,
      Paint()
        ..color = col.withOpacity(.3 + glowT * .1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
