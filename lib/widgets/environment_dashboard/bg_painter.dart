import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

typedef C = AppColors;

class BgPainter extends CustomPainter {
  final double t, glow;
  final WeatherType weather;
  final double windDeg;
  const BgPainter({
    required this.t,
    required this.glow,
    required this.weather,
    required this.windDeg,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.1, -0.5),
          colors: [const Color(0xFF041510), C.bg],
          radius: 1.5,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );

    final gv = (sin(t * pi * 2) + 1) / 2;
    final p = Paint()
      ..color = C.teal.withOpacity(0.005)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }

    // Nature-toned glows
    canvas.drawCircle(
      Offset(s.width * 0.15, s.height * 0.25),
      160,
      Paint()
        ..color = C.teal.withOpacity(0.015 + gv * 0.008)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100),
    );
    canvas.drawCircle(
      Offset(s.width * 0.85, s.height * 0.7),
      120,
      Paint()
        ..color = C.green.withOpacity(0.01 + gv * 0.005)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  @override
  bool shouldRepaint(BgPainter o) => o.t != t || o.weather != weather;
}
