import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class MiniDial extends CustomPainter {
  final double frac;
  final Color color;
  final double pulse;
  MiniDial(this.frac, this.color, this.pulse);

  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width / 2, s.height / 2);
    final r = s.width / 2 - 4;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = AppColors.gBdr
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -pi / 2,
      frac * 2 * pi,
      false,
      Paint()
        ..color = color.withOpacity(0.5 + pulse * 0.2)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(MiniDial old) => old.pulse != pulse;
}
