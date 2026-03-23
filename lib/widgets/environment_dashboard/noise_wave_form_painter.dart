import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class NoiseWaveformPainter extends CustomPainter {
  final double value, glow, animT;
  const NoiseWaveformPainter({
    required this.value,
    required this.glow,
    required this.animT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final norm = ((value - 30) / 90).clamp(0, 1);
    final col = value > 85
        ? C.red
        : value > 70
        ? C.amber
        : C.violet;
    final bars = 48;
    final bw = s.width / bars;

    for (int i = 0; i < bars; i++) {
      final phase = sin((i / bars * 2 * pi * 3) + animT * 2 * pi) * 0.5 + 0.5;
      final bh = (norm * cy * 0.85 * phase + norm * cy * 0.1).clamp(2.0, cy);
      final x = i * bw;
      final alpha = 0.4 + phase * 0.4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1, cy - bh, bw - 2, bh * 2),
          const Radius.circular(2),
        ),
        Paint()
          ..color = col.withOpacity(alpha)
          ..maskFilter = bh > cy * 0.5
              ? MaskFilter.blur(BlurStyle.normal, glow * 2)
              : null,
      );
    }

    // Limit line
    const limitNorm = (70 - 30) / 90;
    final limitY = cy - limitNorm * cy * 0.85;
    canvas.drawLine(
      Offset(0, limitY),
      Offset(s.width, limitY),
      Paint()
        ..color = C.amber.withOpacity(0.5)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(0, cy + (cy - limitY)),
      Offset(s.width, cy + (cy - limitY)),
      Paint()
        ..color = C.amber.withOpacity(0.5)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(NoiseWaveformPainter o) =>
      o.value != value || o.glow != glow || o.animT != animT;
}
