import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class BgPainter extends CustomPainter {
  final double t;
  BgPainter({required this.t});

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.1, -0.3),
          colors: [const Color(0xFF020C18), C.bg],
          radius: 1.4,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    final glow = (sin(t * pi * 2) + 1) / 2;
    final p = Paint()
      ..color = kAccent.withOpacity(0.012 * (0.5 + glow * 0.3))
      ..strokeWidth = 0.35;
    for (double x = 0; x < s.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t;
}
