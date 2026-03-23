import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/district_analytics/radar_axis.dart';

class ComparisonBarPainter extends CustomPainter {
  final List<RadarAxis> district;
  final List<RadarAxis> city;
  final double progress;
  ComparisonBarPainter(this.district, this.city, this.progress);

  @override
  void paint(Canvas canvas, Size s) {
    final n = min(district.length, city.length);
    const lpad = 52.0, rpad = 10.0, tpad = 8.0, bpad = 26.0;
    final w = s.width - lpad - rpad;
    final h = s.height - tpad - bpad;
    final rowH = h / n;

    for (int i = 0; i < n; i++) {
      final a = district[i];
      final b = city[i];
      final y = tpad + i * rowH;

      final distFrac = a.value * progress;
      final cityFrac = b.value * progress;

      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: a.label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: AppColors.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y + rowH / 2 - tp.height - 1));

      // City bar (thinner, behind)
      final cityBarH = rowH * 0.28;
      canvas.drawRRect(
        RRect.fromLTRBR(
          lpad,
          y + rowH / 2 - cityBarH / 2,
          lpad + cityFrac * w,
          y + rowH / 2 + cityBarH / 2,
          const Radius.circular(2),
        ),
        Paint()..color = AppColors.mutedLt.withOpacity(0.25),
      );

      // District bar (thicker)
      final distBarH = rowH * 0.45;
      canvas.drawRRect(
        RRect.fromLTRBR(
          lpad,
          y + rowH * 0.1,
          lpad + distFrac * w,
          y + rowH * 0.1 + distBarH,
          const Radius.circular(2),
        ),
        Paint()..color = a.color.withOpacity(0.6),
      );

      // Value label
      final vp = TextPainter(
        text: TextSpan(
          text: '${(a.value * 100).toInt()}',
          style: TextStyle(fontFamily: 'Orbitron', fontSize: 9, color: a.color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      vp.paint(canvas, Offset(lpad + distFrac * w + 3, y + rowH * 0.1));
    }

    // Legend
    final lp1 = TextPainter(
      text: const TextSpan(
        text: '━ DISTRICT',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          color: AppColors.cyan,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    lp1.paint(canvas, Offset(lpad, s.height - 16));
    final lp2 = TextPainter(
      text: const TextSpan(
        text: '━ CITY AVG',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          color: AppColors.mutedLt,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    lp2.paint(canvas, Offset(lpad + lp1.width + 14, s.height - 16));
  }

  @override
  bool shouldRepaint(ComparisonBarPainter old) => old.progress != progress;
}
