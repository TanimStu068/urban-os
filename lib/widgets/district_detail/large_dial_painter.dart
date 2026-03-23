import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

class LargeDialPainter extends CustomPainter {
  final double frac;
  final Color color;
  final double pulse;
  LargeDialPainter(this.frac, this.color, this.pulse);

  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width / 2, s.height / 2);
    final r = s.width / 2 - 5;
    // Track
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = AppColors.gBdr
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    // Glow
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -pi / 2,
      frac * 2 * pi,
      false,
      Paint()
        ..color = color.withOpacity(0.15 + pulse * 0.08)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -pi / 2,
      frac * 2 * pi,
      false,
      Paint()
        ..color = color
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(LargeDialPainter old) => old.pulse != pulse;
}
