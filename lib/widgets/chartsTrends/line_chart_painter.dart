import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

class LineChartPainter extends CustomPainter {
  final List<SeriesData> series;
  final double progress;
  final int? hoverBucket;
  final int buckets;

  LineChartPainter(this.series, this.progress, this.hoverBucket, this.buckets);

  @override
  void paint(Canvas canvas, Size size) {
    const lpad = 40.0, rpad = 40.0, tpad = 16.0, bpad = 16.0;
    final w = size.width - lpad - rpad;
    final h = size.height - tpad - bpad;
    final chartRect = Rect.fromLTWH(lpad, tpad, w, h);

    // Find global max across all active series
    double globalMax = 1;
    for (final s in series) {
      if (s.maxValue > globalMax) globalMax = s.maxValue;
    }
    globalMax = (globalMax * 1.1).ceilToDouble();

    // Y grid lines
    final gridPaint = Paint()
      ..color = AppColors.gBdr
      ..strokeWidth = 0.5;
    const yLines = 4;
    for (int i = 0; i <= yLines; i++) {
      final y = tpad + h - (i / yLines) * h;
      canvas.drawLine(Offset(lpad, y), Offset(lpad + w, y), gridPaint);
      final val = (globalMax * i / yLines).round();
      final tp = _tp('$val', 7, AppColors.mutedLt);
      tp.paint(canvas, Offset(2, y - 5));
    }

    // Hover vertical
    if (hoverBucket != null) {
      final hx = lpad + (hoverBucket! / (buckets - 1)) * w;
      canvas.drawLine(
        Offset(hx, tpad),
        Offset(hx, tpad + h),
        Paint()
          ..color = AppColors.cyan.withOpacity(0.3)
          ..strokeWidth = 1,
      );
    }

    // Draw each series
    for (final s in series) {
      if (s.points.isEmpty) continue;
      final pts = s.points.length;
      final path = Path();
      final fillPath = Path();

      for (int i = 0; i < pts; i++) {
        final drawI = (i / (pts - 1)) <= progress ? i : -1;
        if (drawI < 0) break;
        final frac = pts == 1 ? 0.0 : i / (pts - 1);
        final x = lpad + frac * w;
        final y = tpad + h - (s.points[i].value / globalMax) * h;
        if (i == 0) {
          path.moveTo(x, y);
          fillPath.moveTo(x, tpad + h);
          fillPath.lineTo(x, y);
        } else {
          path.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }

      // Fill
      fillPath.lineTo(
        lpad + (min(progress, 1) * (pts - 1) / (pts - 1)) * w,
        tpad + h,
      );
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              s.metric.color.withOpacity(0.18),
              s.metric.color.withOpacity(0.0),
            ],
          ).createShader(chartRect)
          ..style = PaintingStyle.fill,
      );

      // Line
      canvas.drawPath(
        path,
        Paint()
          ..color = s.metric.color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      // Dots on hover
      if (hoverBucket != null && hoverBucket! < pts) {
        final hb = hoverBucket!;
        final x = lpad + (hb / (pts - 1)) * w;
        final y = tpad + h - (s.points[hb].value / globalMax) * h;
        canvas.drawCircle(Offset(x, y), 4, Paint()..color = s.metric.color);
        canvas.drawCircle(
          Offset(x, y),
          6,
          Paint()
            ..color = s.metric.color.withOpacity(0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  TextPainter _tp(String t, double sz, Color col) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp;
  }

  @override
  bool shouldRepaint(LineChartPainter old) =>
      old.progress != progress || old.hoverBucket != hoverBucket;
}
