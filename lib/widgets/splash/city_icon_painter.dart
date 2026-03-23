import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class CityIconPainter extends CustomPainter {
  final double t;
  CityIconPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.square;

    final cyanPaint = strokePaint..color = AppColors.cyan;
    final tealPaint = Paint()
      ..color = AppColors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fillCyan = Paint()..color = AppColors.cyan.withOpacity(0.8);
    final fillTeal = Paint()..color = AppColors.teal.withOpacity(0.5 + t * 0.3);
    final dimPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Left building
    canvas.drawRect(
      const Rect.fromLTWH(8, 38, 10, 22),
      strokePaint..color = AppColors.cyan,
    );
    // Mid-left building
    canvas.drawRect(
      const Rect.fromLTWH(20, 28, 12, 32),
      strokePaint..color = AppColors.cyan,
    );
    // Tall center building
    canvas.drawRect(const Rect.fromLTWH(34, 18, 14, 42), tealPaint);
    // Right building
    canvas.drawRect(
      const Rect.fromLTWH(50, 30, 10, 30),
      strokePaint..color = AppColors.cyan,
    );

    // Windows on center building
    final wins = [
      [37.0, 22.0],
      [43.0, 22.0],
      [37.0, 28.0],
      [43.0, 28.0],
      [37.0, 34.0],
      [43.0, 34.0],
    ];
    final winOpacities = [0.8, 0.5, 0.6, 0.9, 0.7, 0.4];
    for (int i = 0; i < wins.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(wins[i][0], wins[i][1], 3, 3),
        Paint()
          ..color = (i % 2 == 0 ? AppColors.teal : AppColors.cyan).withOpacity(
            winOpacities[i],
          ),
      );
    }

    // Antenna
    canvas.drawLine(
      const Offset(41, 18),
      const Offset(41, 10),
      Paint()
        ..color = AppColors.cyan
        ..strokeWidth = 1.2,
    );

    // Antenna top dot with pulse
    final antennaPulse = (sin(t * pi * 2) + 1) / 2;
    canvas.drawCircle(const Offset(41, 9), 2, fillCyan);
    canvas.drawCircle(
      const Offset(41, 9),
      4 + antennaPulse * 2,
      Paint()
        ..color = AppColors.cyan.withOpacity(0.2 + antennaPulse * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Ground line
    canvas.drawLine(
      const Offset(4, 60),
      const Offset(66, 60),
      Paint()
        ..color = AppColors.cyan.withOpacity(0.3)
        ..strokeWidth = 1,
    );

    // Circuit lines at base
    canvas.drawLine(const Offset(4, 64), const Offset(20, 64), dimPaint);
    canvas.drawLine(const Offset(20, 64), const Offset(20, 67), dimPaint);
    canvas.drawLine(const Offset(30, 64), const Offset(50, 64), dimPaint);
    canvas.drawLine(const Offset(50, 64), const Offset(50, 67), dimPaint);
  }

  @override
  bool shouldRepaint(CityIconPainter o) => o.t != t;
}
