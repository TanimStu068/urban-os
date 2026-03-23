import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class BgPainter extends CustomPainter {
  final double t, glow;
  const BgPainter({required this.t, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.4),
          colors: [const Color(0xFF050D08), C.bg],
          radius: 1.4,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    // Grid lines
    final p = Paint()
      ..color = C.amber.withOpacity(0.007)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
    // Orb
    final gv = (sin(t * pi * 2) + 1) / 2;
    canvas.drawCircle(
      Offset(s.width * 0.5, s.height * 0.4),
      200,
      Paint()
        ..color = C.amber.withOpacity(0.012 + gv * 0.006)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100),
    );
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t;
}
