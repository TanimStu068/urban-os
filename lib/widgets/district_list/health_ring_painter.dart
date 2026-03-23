import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

class HealthRingPainter extends CustomPainter {
  final double frac;
  final Color color;
  final double pulse;
  HealthRingPainter(this.frac, this.color, this.pulse);

  @override
  void paint(Canvas canvas, Size s) {
    const stroke = 3.0;
    final r = s.width / 2 - stroke;
    final center = Offset(s.width / 2, s.height / 2);

    // Track
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = AppColors.gBdr
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -pi / 2,
      frac * 2 * pi,
      false,
      Paint()
        ..color = color.withOpacity(0.6 + pulse * 0.2)
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(HealthRingPainter old) =>
      old.pulse != pulse || old.frac != frac;
}
