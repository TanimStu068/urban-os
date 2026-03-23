import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class RingPainter extends CustomPainter {
  final bool inner;
  RingPainter(this.inner);
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.width / 2 - 2;

    // Base dim ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = AppColors.cyan.withOpacity(inner ? 0.08 : 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    if (!inner) {
      // Bright arc segments
      _drawArc(canvas, cx, cy, r, 0, 0.44, 1.5);
      _drawArc(canvas, cx, cy, r, 0.55, 0.11, 1.5);
    } else {
      _drawArc(canvas, cx, cy, r, 0, 0.17, 1.0);
    }
  }

  void _drawArc(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    double startFraction,
    double sweepFraction,
    double width,
  ) {
    final paint = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.cyan, AppColors.teal, AppColors.cyan],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startFraction * 2 * pi,
      sweepFraction * 2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
