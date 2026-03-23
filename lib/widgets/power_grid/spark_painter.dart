import 'package:flutter/material.dart';
import 'dart:math';

class SparkPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double glowT;
  const SparkPainter({
    required this.data,
    required this.color,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (data.length < 2) return;
    final maxV = data.reduce(max);
    if (maxV == 0) return;
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * s.width;
      final y = s.height - (data[i] / maxV).clamp(0, 1) * s.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.8)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 + glowT * 0.5),
    );
  }

  @override
  bool shouldRepaint(SparkPainter o) => o.glowT != glowT;
}
