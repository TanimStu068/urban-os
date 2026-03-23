import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

AQILevel _aqiLevel(double aqi) {
  if (aqi <= 50) return AQILevel(label: 'Good', color: C.green, index: 0);
  if (aqi <= 100) return AQILevel(label: 'Moderate', color: C.yellow, index: 1);
  if (aqi <= 150) {
    return AQILevel(label: 'Unhealthy', color: C.orange, index: 2);
  }
  if (aqi <= 200) {
    return AQILevel(label: 'Very Unhealthy', color: C.red, index: 3);
  }
  return AQILevel(label: 'Hazardous', color: C.violet, index: 4);
}

class AQILevel {
  final String label;
  final Color color;
  final int index;
  AQILevel({required this.label, required this.color, required this.index});
}

class PollutionMapPainter extends CustomPainter {
  final List<DistrictEnvData> districts;
  final double glow, blink;
  final String? selectedId;
  const PollutionMapPainter({
    required this.districts,
    required this.glow,
    required this.blink,
    required this.selectedId,
  });

  @override
  void paint(Canvas canvas, Size s) {
    // Background grid
    final p = Paint()
      ..color = C.muted.withOpacity(0.08)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
    for (final d in districts) {
      final x = d.gridPos.dx * s.width;
      final y = d.gridPos.dy * s.height;
      final aqiNorm = (d.aqi / 200).clamp(0, 1);
      final lvl = _aqiLevel(d.aqi);
      final isSel = selectedId == d.id;
      final r = 22.0;

      // Heatmap blob
      canvas.drawCircle(
        Offset(x, y),
        r * 2.2,
        Paint()
          ..color = lvl.color.withOpacity(0.07 + aqiNorm * 0.1 + glow * 0.03)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );

      // Pulse ring for critical
      if (d.aqi > 130) {
        canvas.drawCircle(
          Offset(x, y),
          r + 8 + blink * 6,
          Paint()
            ..color = lvl.color.withOpacity((0.4 - blink * 0.3).clamp(0, 0.4))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
      }

      // Selection ring
      if (isSel) {
        canvas.drawCircle(
          Offset(x, y),
          r + 6,
          Paint()
            ..color = d.color.withOpacity(0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8,
        );
      }

      // Node circle
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = C.bgCard.withOpacity(0.92),
      );
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = lvl.color.withOpacity(
            isSel ? 0.5 + glow * 0.15 : 0.35 + glow * 0.1,
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // AQI number
      final tp = TextPainter(
        text: TextSpan(
          text: d.aqi.toStringAsFixed(0),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: lvl.color,
            shadows: [Shadow(color: lvl.color.withOpacity(0.5), blurRadius: 5)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

      // Label below
      final lp = TextPainter(
        text: TextSpan(
          text: d.name,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: d.color.withOpacity(0.8),
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y + r + 9),
            width: lp.width + 8,
            height: lp.height + 4,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = C.bgCard3.withOpacity(0.9),
      );
      lp.paint(canvas, Offset(x - lp.width / 2, y + r + 6));
    }

    // Legend
    final lvls = [
      AqiLevel.good,
      AqiLevel.moderate,
      AqiLevel.unhealthySensitive,
      AqiLevel.unhealthy,
    ];
    double lx = 6;
    for (final lvl in lvls) {
      canvas.drawCircle(
        Offset(lx + 5, s.height - 7),
        4,
        Paint()..color = lvl.color,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: lvl.label.split(' ').first,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: lvl.color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx + 12, s.height - 12));
      lx += tp.width + 22;
    }
  }

  @override
  bool shouldRepaint(PollutionMapPainter o) =>
      o.glow != glow || o.blink != blink || o.selectedId != selectedId;
}
