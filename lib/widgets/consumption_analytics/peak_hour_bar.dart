import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'dart:math';

typedef C = AppColors;

class PeakHourBarPainter extends CustomPainter {
  final List<ConsumptionPoint> series;
  final double glowT;
  const PeakHourBarPainter({required this.series, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    if (series.isEmpty) return;
    final maxV = series.map((p) => p.value).reduce(max);
    final barW = s.width / series.length;
    for (int i = 0; i < series.length; i++) {
      final norm = (series[i].value / maxV).clamp(0, 1);
      final isPeak = norm > 0.7;
      final col = isPeak
          ? C.amber
          : norm > 0.45
          ? C.cyan
          : C.mutedLt;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * barW + 0.5,
            s.height * (1 - norm),
            barW - 1,
            s.height * norm,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = col.withOpacity(0.6 + glowT * 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(PeakHourBarPainter o) => o.glowT != glowT;
}
