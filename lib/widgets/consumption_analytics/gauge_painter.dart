import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final double glowT;
  const GaugePainter({
    required this.value,
    required this.color,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height * 0.85;
    final r = min(cx, cy) * 0.85;
    const startA = pi, sweepA = pi;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      sweepA,
      false,
      Paint()
        ..color = C.muted.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    // Zones
    for (int i = 0; i < 3; i++) {
      final zColors = [C.green, C.amber, C.red];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startA + (i / 3) * sweepA,
        sweepA / 3,
        false,
        Paint()
          ..color = zColors[i].withOpacity(0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8,
      );
    }
    // Value arc glow
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      (value / 100) * sweepA,
      false,
      Paint()
        ..color = color.withOpacity(0.3 + glowT * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    // Value arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      (value / 100) * sweepA,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    // Needle
    final angle = pi + (value / 100) * pi;
    final needleLen = r * 0.75;
    final nx = cx + cos(angle) * needleLen;
    final ny = cy + sin(angle) * needleLen;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(nx, ny),
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = color);

    // Value text
    final tp = TextPainter(
      text: TextSpan(
        text: '${value.toStringAsFixed(0)}%',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height - 10));
    const sub = TextSpan(
      text: 'PEAK RATIO',
      style: TextStyle(fontFamily: 'monospace', fontSize: 6.5, color: C.muted),
    );
    final sp = TextPainter(text: sub, textDirection: TextDirection.ltr)
      ..layout();
    sp.paint(canvas, Offset(cx - sp.width / 2, cy - 8));
  }

  @override
  bool shouldRepaint(GaugePainter o) => o.value != value || o.glowT != glowT;
}
