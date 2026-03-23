import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

class Slice {
  final Color color;
  final double frac;
  final String label;
  const Slice(this.color, this.frac, this.label);
}

class DonutPainter extends CustomPainter {
  final List<Slice> slices;
  DonutPainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = min(cx, cy) - 8;
    double start = -pi / 2;
    for (final s in slices) {
      final sweep = s.frac * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep,
        false,
        Paint()
          ..color = s.color
          ..strokeWidth = 14
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
    // Inner label
    final tp = TextPainter(
      text: const TextSpan(
        text: 'DIST',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 8,
          color: AppColors.mutedLt,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(DonutPainter old) => false;
}
