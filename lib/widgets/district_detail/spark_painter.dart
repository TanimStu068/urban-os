import 'package:flutter/material.dart';
import 'dart:math';

class SparkPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  SparkPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    final minV = data.reduce(min) - 2;
    final maxV = data.reduce(max) + 2;
    final range = maxV == minV ? 1.0 : maxV - minV;
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * s.width;
      final y = s.height - ((data[i] - minV) / range) * s.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    // Fill
    final fillPath = Path.from(path)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.18), color.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(SparkPainter old) => false;
}
