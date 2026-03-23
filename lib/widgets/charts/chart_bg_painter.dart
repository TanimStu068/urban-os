import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ChartsBgPainter extends CustomPainter {
  final double glowT;
  ChartsBgPainter({required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.2, -.6),
          colors: [const Color(0xFF041520), C.bg],
          radius: 1.6,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    final glv = (math.sin(glowT * math.pi * 2) + 1) / 2;
    final gp = Paint()
      ..color = C.trafficCyan.withOpacity(.007 * (0.4 + glv * .4))
      ..strokeWidth = .35;
    for (double x = 0; x < s.width; x += 52)
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    for (double y = 0; y < s.height; y += 52)
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);

    canvas.drawCircle(
      Offset(s.width * .8, s.height * .25),
      130,
      Paint()
        ..color = C.trafficCyan.withOpacity(.012 + glv * .006)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  @override
  bool shouldRepaint(ChartsBgPainter o) => o.glowT != glowT;
}
