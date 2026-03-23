import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'dart:math';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class ParkingDonutPainter extends CustomPainter {
  final List<ParkingZone> zones;
  final double glowT;
  ParkingDonutPainter({required this.zones, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = min(cx, cy) - 16;
    final totalSpaces = zones.fold(0, (acc, z) => acc + z.total).toDouble();
    double start = -pi / 2;

    for (final z in zones) {
      final sweep = (z.total / totalSpaces) * 2 * pi;
      // Occupied arc
      final occSweep = sweep * z.occupancyRate;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep - .04,
        false,
        Paint()
          ..color = z.color.withOpacity(.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18
          ..strokeCap = StrokeCap.butt,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        occSweep - .04,
        false,
        Paint()
          ..color = z.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18
          ..strokeCap = StrokeCap.butt,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        occSweep - .04,
        false,
        Paint()
          ..color = z.color.withOpacity(.3 + glowT * .1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 24
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      start += sweep;
    }

    // Center text
    canvas.drawCircle(Offset(cx, cy), r - 24, Paint()..color = C.bgCard);
    final totalOcc = zones.fold(0, (acc, z) => acc + z.occupied);
    final totalCap = zones.fold(0, (acc, z) => acc + z.total);
    final pct = (totalOcc / totalCap * 100).toStringAsFixed(0);
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$pct%\n',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: kAccent,
            ),
          ),
          const TextSpan(
            text: 'OCCUPIED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              letterSpacing: 2,
              color: C.muted,
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
  bool shouldRepaint(ParkingDonutPainter o) => o.glowT != glowT;
}
