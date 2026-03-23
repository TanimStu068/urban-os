import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RadialGaugePainter extends CustomPainter {
  final double value, glow;
  final Color color;
  final String label;
  const RadialGaugePainter({
    required this.value,
    required this.glow,
    required this.color,
    required this.label,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height * 0.75;
    final r = min(cx, cy) * 0.88;
    const startA = pi * 0.75, sweepA = pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      sweepA,
      false,
      Paint()
        ..color = C.muted.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      sweepA * value,
      false,
      Paint()
        ..color = color.withOpacity(0.3 + glow * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      sweepA * value,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color,
          shadows: [Shadow(color: color.withOpacity(0.4), blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: s.width);
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2 + 2));
  }

  @override
  bool shouldRepaint(RadialGaugePainter o) =>
      o.value != value || o.glow != glow;
}
