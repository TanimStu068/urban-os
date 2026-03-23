import 'package:flutter/material.dart';
import 'dart:math';

class AreaSparkPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double glowT;
  const AreaSparkPainter({
    required this.data,
    required this.color,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    final maxV = data.reduce(max);
    if (maxV == 0) return;
    final path = Path(), fill = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * s.width;
      final y = s.height - (data[i] / maxV).clamp(0, 1) * s.height;
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, s.height);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(s.width, s.height);
    fill.close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.2), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 + glowT * 0.5),
    );
  }

  @override
  bool shouldRepaint(AreaSparkPainter o) => o.glowT != glowT;
}
