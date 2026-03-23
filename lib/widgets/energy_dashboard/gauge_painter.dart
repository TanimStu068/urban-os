import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class GaugePainter extends CustomPainter {
  final double value; // 0-100
  final Color color;
  final double glowT;

  GaugePainter({required this.value, required this.color, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    final center = Offset(s.width / 2, s.height / 2 + 4);
    final r = min(s.width, s.height) / 2 - 6;
    const startA = pi * 0.75;
    const sweepA = pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      startA,
      sweepA,
      false,
      Paint()
        ..color = C.muted.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    // Value arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      startA,
      sweepA * (value / 100),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 + glowT),
    );
    // Center text
    final tp = TextPainter(
      text: TextSpan(
        text: '${value.toStringAsFixed(0)}%',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
    // Eff label
    final lp = TextPainter(
      text: const TextSpan(
        text: 'EFF',
        style: TextStyle(fontFamily: 'monospace', fontSize: 6, color: C.muted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    lp.paint(
      canvas,
      Offset(center.dx - lp.width / 2, center.dy + tp.height / 2 - 1),
    );
  }

  @override
  bool shouldRepaint(GaugePainter o) => o.value != value || o.glowT != glowT;
}

/// Sparkline
