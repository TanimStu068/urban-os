import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'dart:math';

class MainChartPainter extends CustomPainter {
  final List<ConsumptionPoint> series;
  final TimeRange range;
  final ChartMode mode;
  final bool showCompare, showForecast, showCost;
  final double animT, glowT;
  final int hoverIdx;

  const MainChartPainter({
    required this.series,
    required this.range,
    required this.mode,
    required this.showCompare,
    required this.showForecast,
    required this.showCost,
    required this.animT,
    required this.glowT,
    required this.hoverIdx,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (series.isEmpty) return;
    const padL = 36.0, padR = 12.0, padT = 12.0, padB = 22.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;
    final n = series.length;

    final vals = showCost
        ? series.map((p) => p.cost).toList()
        : series.map((p) => p.value).toList();
    final prevVals = showCost
        ? series.map((p) => p.prevValue * 0.00015).toList()
        : series.map((p) => p.prevValue).toList();
    final foreVals = series.map((p) => p.forecast).toList();

    final allVals = [
      ...vals,
      if (showCompare) ...prevVals,
      if (showForecast) ...foreVals,
    ];
    final maxV = allVals.isEmpty ? 1.0 : allVals.reduce(max) * 1.12;

    // Grid
    for (int i = 0; i <= 4; i++) {
      final y = padT + h - (i / 4) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(padL + w, y),
        Paint()
          ..color = C.muted.withOpacity(0.15)
          ..strokeWidth = 0.5,
      );
      final label = showCost
          ? '\$${((i / 4) * maxV).toStringAsFixed(0)}'
          : '${((i / 4) * maxV / 1000).toStringAsFixed(1)}M';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padL - tp.width - 3, y - tp.height / 2));
    }

    // Vertical grid & X labels
    final step = (n / 6).ceil();
    for (int i = 0; i < n; i += step) {
      final x = padL + (i / (n - 1)) * w;
      canvas.drawLine(
        Offset(x, padT),
        Offset(x, padT + h),
        Paint()
          ..color = C.muted.withOpacity(0.08)
          ..strokeWidth = 0.5,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: range.xLabel(i),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, padT + h + 5));
    }

    void drawArea(
      List<double> data,
      Color col, {
      bool dashed = false,
      bool filled = true,
    }) {
      final visibleN = (n * animT).clamp(1, n).toInt();
      final path = Path();
      final fPath = Path();
      bool started = false;
      for (int i = 0; i < visibleN; i++) {
        final x = padL + (i / (n - 1)) * w;
        final y = padT + h - (data[i] / maxV).clamp(0, 1) * h;
        if (!started) {
          path.moveTo(x, y);
          fPath.moveTo(x, padT + h);
          fPath.lineTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
          fPath.lineTo(x, y);
        }
      }
      if (filled) {
        fPath.lineTo(padL + ((visibleN - 1) / (n - 1)) * w, padT + h);
        fPath.close();
        canvas.drawPath(
          fPath,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                col.withOpacity(0.16 + glowT * 0.05),
                col.withOpacity(0),
              ],
            ).createShader(Rect.fromLTWH(padL, padT, w, h)),
        );
      }
      // Glow
      canvas.drawPath(
        path,
        Paint()
          ..color = col.withOpacity(0.25 + glowT * 0.1)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      // Line
      if (dashed) {
        _drawDashed(canvas, path, col, 1.5);
      } else {
        canvas.drawPath(
          path,
          Paint()
            ..color = col
            ..strokeWidth = 2.2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Comparison first (behind)
    if (showCompare) drawArea(prevVals, C.cyan.withOpacity(0.6), filled: false);
    // Forecast
    if (showForecast) drawArea(foreVals, C.violet, dashed: true, filled: false);
    // Main area
    drawArea(vals, C.amber);

    // Anomaly dots
    for (int i = 0; i < n && i < (n * animT).toInt(); i++) {
      if (!series[i].isAnomaly) continue;
      final x = padL + (i / (n - 1)) * w;
      final y = padT + h - (vals[i] / maxV).clamp(0, 1) * h;
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()
          ..color = C.red.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = C.red);
    }

    // Hover crosshair
    if (hoverIdx >= 0 && hoverIdx < n) {
      final x = padL + (hoverIdx / (n - 1)) * w;
      final y = padT + h - (vals[hoverIdx] / maxV).clamp(0, 1) * h;
      canvas.drawLine(
        Offset(x, padT),
        Offset(x, padT + h),
        Paint()
          ..color = C.amber.withOpacity(0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()..color = C.amber.withOpacity(0.2),
      );
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = C.amber);
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  void _drawDashed(Canvas canvas, Path path, Color col, double sw) {
    final metric = path.computeMetrics().first;
    const dash = 6.0, gap = 4.0;
    double pos = 0;
    while (pos < metric.length) {
      final end = min(pos + dash, metric.length);
      canvas.drawPath(
        metric.extractPath(pos, end),
        Paint()
          ..color = col
          ..strokeWidth = sw
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      pos += dash + gap;
    }
  }

  @override
  bool shouldRepaint(MainChartPainter o) =>
      o.animT != animT ||
      o.glowT != glowT ||
      o.hoverIdx != hoverIdx ||
      o.showCompare != showCompare ||
      o.showForecast != showForecast;
}
