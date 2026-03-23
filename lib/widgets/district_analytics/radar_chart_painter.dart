import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/district_analytics/radar_axis.dart';

class RadarChartPainter extends CustomPainter {
  final List<RadarAxis> axes;
  final double progress;
  final double pulse;
  RadarChartPainter(this.axes, this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size s) {
    final n = axes.length;
    if (n < 3) return;
    final c = Offset(s.width / 2, s.height / 2);
    final maxR = min(s.width, s.height) / 2 - 20;
    const rings = 4;

    // Ring grid
    final ringPaint = Paint()
      ..color = AppColors.gBdr
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (int r = 1; r <= rings; r++) {
      final rr = maxR * r / rings;
      final path = Path();
      for (int i = 0; i <= n; i++) {
        final angle = -pi / 2 + i * 2 * pi / n;
        final p = Offset(c.dx + cos(angle) * rr, c.dy + sin(angle) * rr);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, ringPaint);
    }

    // Axis spokes
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * 2 * pi / n;
      canvas.drawLine(
        c,
        Offset(c.dx + cos(angle) * maxR, c.dy + sin(angle) * maxR),
        Paint()
          ..color = AppColors.gBdr
          ..strokeWidth = 0.5,
      );
    }

    // Data polygon
    final filled = Path();
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * 2 * pi / n;
      final r = maxR * axes[i].value * progress;
      final p = Offset(c.dx + cos(angle) * r, c.dy + sin(angle) * r);
      i == 0 ? filled.moveTo(p.dx, p.dy) : filled.lineTo(p.dx, p.dy);
    }
    filled.close();

    // Fill
    canvas.drawPath(
      filled,
      Paint()
        ..color = AppColors.cyan.withOpacity(0.08 + pulse * 0.03)
        ..style = PaintingStyle.fill,
    );
    // Stroke
    canvas.drawPath(
      filled,
      Paint()
        ..color = AppColors.cyan.withOpacity(0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots + labels
    for (int i = 0; i < n; i++) {
      final angle = -pi / 2 + i * 2 * pi / n;
      final r = maxR * axes[i].value * progress;
      final p = Offset(c.dx + cos(angle) * r, c.dy + sin(angle) * r);
      canvas.drawCircle(p, 3.5, Paint()..color = axes[i].color);

      // Label
      final lp = Offset(
        c.dx + cos(angle) * (maxR + 16),
        c.dy + sin(angle) * (maxR + 16),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: axes[i].label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: axes[i].color,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(RadarChartPainter old) =>
      old.progress != progress || old.pulse != pulse;
}
