import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

AQILevel _aqiLevel(double aqi) {
  if (aqi <= 50) return AQILevel(label: 'Good', color: C.green, index: 0);
  if (aqi <= 100) return AQILevel(label: 'Moderate', color: C.yellow, index: 1);
  if (aqi <= 150)
    return AQILevel(label: 'Unhealthy', color: C.orange, index: 2);
  if (aqi <= 200)
    return AQILevel(label: 'Very Unhealthy', color: C.red, index: 3);
  return AQILevel(label: 'Hazardous', color: C.violet, index: 4);
}

class AQILevel {
  final String label;
  final Color color;
  final int index;
  AQILevel({required this.label, required this.color, required this.index});
}

class BigAqiGaugePainter extends CustomPainter {
  final double aqi, glow;
  const BigAqiGaugePainter({required this.aqi, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height * 0.82;
    final r = min(cx, s.height * 0.85) - 8;
    const startA = pi, sweepTotal = pi;
    final colors = [C.green, C.lime, C.yellow, C.amber, C.orange, C.red];
    const bands = [50.0, 100.0, 150.0, 200.0, 300.0, 500.0];

    // Color bands
    double prev = 0;
    for (int i = 0; i < bands.length; i++) {
      final sw = (bands[i] - prev) / 500 * sweepTotal;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startA + prev / 500 * sweepTotal,
        sw,
        false,
        Paint()
          ..color = colors[i].withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20,
      );
      // Band label
      final midA = startA + (prev + (bands[i] - prev) / 2) / 500 * sweepTotal;
      final lx = cx + cos(midA) * (r + 18);
      final ly = cy + sin(midA) * (r + 18);
      final tp = TextPainter(
        text: TextSpan(
          text: '${bands[i].toInt()}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: colors[i].withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
      prev = bands[i];
    }

    // Value arc
    final valueA = (aqi / 500).clamp(0, 1) * sweepTotal;
    final col = _aqiLevel(aqi).color;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      valueA,
      false,
      Paint()
        ..color = col.withOpacity(0.3 + glow * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 26
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      valueA,
      false,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round,
    );

    // Needle
    final nAngle = startA + valueA;
    final nEnd = Offset(
      cx + cos(nAngle) * (r - 12),
      cy + sin(nAngle) * (r - 12),
    );
    canvas.drawLine(
      Offset(cx, cy),
      nEnd,
      Paint()
        ..color = col
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(cx, cy), 7, Paint()..color = C.bgCard);
    canvas.drawCircle(
      Offset(cx, cy),
      7,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Center
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${aqi.toStringAsFixed(0)}  ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: col,
              shadows: [Shadow(color: col, blurRadius: 12)],
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height - 8));

    final lvlTp = TextPainter(
      text: TextSpan(
        text: _aqiLevel(aqi).label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          color: col,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    lvlTp.paint(canvas, Offset(cx - lvlTp.width / 2, cy - 10));
  }

  @override
  bool shouldRepaint(BigAqiGaugePainter o) => o.aqi != aqi || o.glow != glow;
}
