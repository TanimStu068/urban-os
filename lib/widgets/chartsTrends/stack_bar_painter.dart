import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

class StackedBarPainter extends CustomPainter {
  final List<SeriesData> series;
  final double progress;
  final int? hover;

  StackedBarPainter(this.series, this.progress, this.hover);

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;
    final buckets = series.first.points.length;
    if (buckets == 0) return;
    const pad = 2.0;
    final barW = (size.width / buckets) - pad;

    // Find global max stacked
    double globalMax = 1;
    for (int b = 0; b < buckets; b++) {
      double sum = 0;
      for (final s in series) {
        if (b < s.points.length) sum += s.points[b].value;
      }
      if (sum > globalMax) globalMax = sum;
    }

    for (int b = 0; b < buckets; b++) {
      if ((b / (buckets - 1)) > progress) break;
      final x = b * (barW + pad);
      double base = size.height;
      for (final s in series) {
        if (b >= s.points.length) continue;
        final val = s.points[b].value;
        final barH = (val / globalMax) * size.height;
        base -= barH;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, base, barW, barH),
          const Radius.circular(1.5),
        );
        canvas.drawRRect(
          rect,
          Paint()..color = s.metric.color.withOpacity(hover == b ? 0.55 : 0.30),
        );
      }
      if (hover == b) {
        canvas.drawRect(
          Rect.fromLTWH(x, 0, barW, size.height),
          Paint()..color = AppColors.white.withOpacity(0.04),
        );
      }
    }
  }

  @override
  bool shouldRepaint(StackedBarPainter old) =>
      old.progress != progress || old.hover != hover;
}
