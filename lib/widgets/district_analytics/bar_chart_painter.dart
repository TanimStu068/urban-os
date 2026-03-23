import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

import 'package:urban_os/widgets/district_analytics/radar_axis.dart';

class BarChartPainter extends CustomPainter {
  final List<RadarAxis> axes;
  final double progress;
  BarChartPainter(this.axes, this.progress);

  @override
  void paint(Canvas canvas, Size s) {
    if (axes.isEmpty) return;
    const lpad = 48.0, rpad = 10.0, tpad = 10.0, bpad = 28.0;
    final w = s.width - lpad - rpad;
    final h = s.height - tpad - bpad;
    final barW = w / axes.length * 0.6;
    final spacing = w / axes.length;

    // Y grid
    for (int i = 0; i <= 4; i++) {
      final y = tpad + h - (i / 4) * h;
      canvas.drawLine(
        Offset(lpad, y),
        Offset(lpad + w, y),
        Paint()
          ..color = AppColors.gBdr
          ..strokeWidth = 0.4,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${i * 25}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: AppColors.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - 5));
    }

    for (int i = 0; i < axes.length; i++) {
      final a = axes[i];
      final x = lpad + i * spacing + spacing / 2 - barW / 2;
      final barH = a.value * h * progress;
      final y = tpad + h - barH;

      // Glow
      canvas.drawRRect(
        RRect.fromLTRBR(
          x - 2,
          y - 4,
          x + barW + 2,
          tpad + h + 4,
          const Radius.circular(4),
        ),
        Paint()
          ..color = a.color.withOpacity(0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      // Bar
      canvas.drawRRect(
        RRect.fromLTRBR(x, y, x + barW, tpad + h, const Radius.circular(3)),
        Paint()..color = a.color.withOpacity(0.3),
      );
      canvas.drawRRect(
        RRect.fromLTRBR(
          x,
          y,
          x + barW,
          y + min(barH, 4),
          const Radius.circular(3),
        ),
        Paint()..color = a.color.withOpacity(0.8),
      );

      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: a.label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: a.color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(x + barW / 2, tpad + h + 5);
      canvas.rotate(-pi / 4);
      tp.paint(canvas, Offset(-tp.width / 2, 0));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) => old.progress != progress;
}
