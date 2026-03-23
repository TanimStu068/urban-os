import 'package:flutter/material.dart';
import 'dart:math';

class SparkBarPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double glowT;
  SparkBarPainter({
    required this.data,
    required this.color,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    final maxV = data.reduce(max);
    if (maxV == 0) return;
    final barW = s.width / data.length;
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    for (int i = 0; i < data.length; i++) {
      final h = (data[i] / maxV) * (s.height - 14);
      final x = i * barW + barW * 0.2;
      final bw = barW * 0.6;
      final y = s.height - 14 - h;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, bw, h),
          const Radius.circular(2),
        ),
        Paint()
          ..color = color.withOpacity(0.15 + glowT * 0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      if (h > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, bw, h),
            const Radius.circular(2),
          ),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [color.withOpacity(0.5), color],
            ).createShader(Rect.fromLTWH(x, y, bw, h)),
        );
      }
      final tp = TextPainter(
        text: TextSpan(
          text: days[i % 7],
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: color.withOpacity(0.4),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + bw / 2 - tp.width / 2, s.height - 11));
    }
  }

  @override
  bool shouldRepaint(SparkBarPainter o) => o.glowT != glowT;
}
