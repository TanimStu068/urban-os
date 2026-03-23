import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'dart:math';

class PieChartPainter extends CustomPainter {
  final List<PollutionSource> sources;
  final double glow;

  PieChartPainter({required this.sources, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 45.0;

    var startAngle = -pi / 2;

    for (final source in sources) {
      final sweepAngle = (source.percentage / 100) * 2 * pi;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = source.color.withOpacity(0.7 + glow * 0.2)
          ..style = PaintingStyle.fill,
      );

      startAngle += sweepAngle;
    }

    // Center circle for donut effect
    canvas.drawCircle(center, radius * 0.6, Paint()..color = C.bg);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => glow != oldDelegate.glow;
}
