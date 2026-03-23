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

class AqiDonutPainter extends CustomPainter {
  final double aqi;
  final double glow;
  const AqiDonutPainter({required this.aqi, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = min(cx, cy) - 12;
    const levels = [50.0, 100.0, 150.0, 200.0, 300.0, 500.0];
    final colors = [C.green, C.lime, C.yellow, C.amber, C.orange, C.red];
    const total = 500.0;
    const startA = -pi * 0.8, sweepTotal = pi * 1.6;

    // Background track
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      sweepTotal,
      false,
      Paint()
        ..color = C.muted.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    // Color segments
    double prev = 0;
    for (int i = 0; i < levels.length; i++) {
      final segSweep = (levels[i] - prev) / total * sweepTotal;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startA + prev / total * sweepTotal,
        segSweep,
        false,
        Paint()
          ..color = colors[i].withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14,
      );
      prev = levels[i];
    }

    // Value arc glow
    final valueSweep = (aqi / total).clamp(0, 1) * sweepTotal;
    final aqiColor = _aqiLevel(aqi).color;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      valueSweep,
      false,
      Paint()
        ..color = aqiColor.withOpacity(0.35 + glow * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startA,
      valueSweep,
      false,
      Paint()
        ..color = aqiColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    // Needle tip
    final tipAngle = startA + valueSweep;
    final tx = cx + cos(tipAngle) * r;
    final ty = cy + sin(tipAngle) * r;
    canvas.drawCircle(
      Offset(tx, ty),
      5,
      Paint()
        ..color = aqiColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(tx, ty), 4, Paint()..color = Colors.white);

    // Center text
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${aqi.toStringAsFixed(0)}\n',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: aqiColor,
              shadows: [Shadow(color: aqiColor, blurRadius: 10)],
            ),
          ),
          const TextSpan(
            text: 'AQI',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.mutedLt,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(AqiDonutPainter o) => o.aqi != aqi || o.glow != glow;
}
