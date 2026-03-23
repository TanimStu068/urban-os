import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'dart:math';
class AnomalyChartPainter extends CustomPainter {
  final List<ConsumptionPoint> series;
  final double glowT, blinkT;
  const AnomalyChartPainter({
    required this.series,
    required this.glowT,
    required this.blinkT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (series.isEmpty) return;
    const padL = 8.0, padR = 8.0, padT = 8.0, padB = 8.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;
    final n = series.length;

    // Deviation = (actual - expected) / expected
    final devs = series
        .map(
          (p) =>
              ((p.value - p.prevValue) / p.prevValue * 100).clamp(-50.0, 100.0),
        )
        .toList();
    final maxDev = devs.map((d) => d.abs()).reduce(max).clamp(1.0, 100.0);

    // Zero line
    final zeroY = padT + h / 2;
    canvas.drawLine(
      Offset(padL, zeroY),
      Offset(padL + w, zeroY),
      Paint()
        ..color = C.mutedLt.withOpacity(0.4)
        ..strokeWidth = 0.5,
    );

    // Bars
    final bW = (w / n) - 1.5;
    for (int i = 0; i < n; i++) {
      final d = devs[i];
      final isAnom = series[i].isAnomaly;
      final col = isAnom
          ? C.red
          : d > 15
          ? C.orange
          : d > 5
          ? C.amber
          : d < -5
          ? C.green
          : C.mutedLt;
      final barH = (d.abs() / maxDev) * (h / 2);
      final x = padL + i * (w / n);
      final y = d >= 0 ? zeroY - barH : zeroY;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 0.5, y, bW, barH.abs().clamp(1, h)),
          const Radius.circular(2),
        ),
        Paint()
          ..color = col.withOpacity(isAnom ? 0.5 + blinkT * 0.3 : 0.45)
          ..maskFilter = isAnom
              ? MaskFilter.blur(BlurStyle.normal, 2 + glowT * 2)
              : null,
      );
    }
  }

  @override
  bool shouldRepaint(AnomalyChartPainter o) =>
      o.glowT != glowT || o.blinkT != blinkT;
}
