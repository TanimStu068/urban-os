import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class HealthScorePainter extends CustomPainter {
  final double score;
  final double glow;
  final Color selectedColor;

  HealthScorePainter({
    required this.score,
    required this.glow,
    required this.selectedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = C.bgCard2
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // Progress arc
    final angle = (score / 100) * 2 * pi - pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      Paint()
        ..color = selectedColor.withOpacity(0.7 + glow * 0.2)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Score text
    final tp = TextPainter(
      text: TextSpan(
        text: '${score.toStringAsFixed(0)}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: selectedColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(HealthScorePainter oldDelegate) =>
      score != oldDelegate.score || glow != oldDelegate.glow;
}
