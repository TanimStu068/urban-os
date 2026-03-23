import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

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
          center: const Alignment(0.3, -0.4),
          colors: [const Color(0xFF050C08), C.bg],
          radius: 1.4,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    final glowV = (sin(t * pi * 2) + 1) / 2;
    final p = Paint()
      ..color = C.amber.withOpacity(0.006)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 52) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 52) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
    canvas.drawCircle(
      Offset(s.width * 0.8, s.height * 0.15),
      130,
      Paint()
        ..color = C.amber.withOpacity(0.012 + glowV * 0.007)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90),
    );
    canvas.drawCircle(
      Offset(s.width * 0.1, s.height * 0.7),
      90,
      Paint()
        ..color = C.cyan.withOpacity(0.007 + glowV * 0.004)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
    );
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t;
}
