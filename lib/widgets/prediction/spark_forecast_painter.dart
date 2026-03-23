import 'package:flutter/material.dart';
import 'dart:math';

class SparkForecastPainter extends CustomPainter {
  final List<double> history;
  final List<double> forecast;
  final Color hCol;
  final Color fCol;
  SparkForecastPainter(this.history, this.forecast, this.hCol, this.fCol);

  @override
  void paint(Canvas canvas, Size size) {
    final all = [...history, ...forecast];
    if (all.isEmpty) return;
    final minV = all.reduce(min);
    final maxV = all.reduce(max);
    final range = maxV == minV ? 1.0 : maxV - minV;
    final total = all.length;
    double x(int i) => i / (total - 1) * size.width;
    double y(double v) =>
        size.height -
        ((v - minV) / range) * size.height * 0.85 -
        size.height * 0.05;

    final hPath = Path();
    for (int i = 0; i < history.length; i++) {
      i == 0 ? hPath.moveTo(x(i), y(all[i])) : hPath.lineTo(x(i), y(all[i]));
    }
    canvas.drawPath(
      hPath,
      Paint()
        ..color = hCol
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final fPath = Path();
    for (int i = 0; i < forecast.length; i++) {
      final gi = history.length + i;
      i == 0
          ? fPath.moveTo(x(gi), y(all[gi]))
          : fPath.lineTo(x(gi), y(all[gi]));
    }
    canvas.drawPath(
      fPath,
      Paint()
        ..color = fCol
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(SparkForecastPainter old) => false;
}
