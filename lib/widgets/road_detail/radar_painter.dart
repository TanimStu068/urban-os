import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RadarPainter extends CustomPainter {
  final RoadDetailData road;
  final double t, glowT;
  RadarPainter({required this.road, required this.t, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = min(cx, cy) - 32;

    final labels = [
      'FLOW',
      'SAFETY',
      'SPEED',
      'RELIABILITY',
      'CAPACITY',
      'SENSORS',
    ];
    final values = [
      1 - road.congestion / 100,
      road.incidents == 0 ? 0.95 : (1 - road.incidents * 0.25).clamp(0.1, 1.0),
      road.speed / road.speedLimit,
      road.reliability,
      road.vehicles / road.capacity,
      road.sensors.where((s) => s.isOnline).length / road.sensors.length,
    ];
    final n = labels.length;
    final angleStep = 2 * pi / n;

    for (int ring = 1; ring <= 4; ring++) {
      final rr = r * ring / 4;
      final pts = List.generate(n, (i) {
        final a = -pi / 2 + i * angleStep;
        return Offset(cx + rr * cos(a), cy + rr * sin(a));
      });
      final path = Path()..moveTo(pts.last.dx, pts.last.dy);
      for (final p in pts) path.lineTo(p.dx, p.dy);
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = kAccent.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    for (int i = 0; i < n; i++) {
      final a = -pi / 2 + i * angleStep;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + r * cos(a), cy + r * sin(a)),
        Paint()
          ..color = kAccent.withOpacity(0.08)
          ..strokeWidth = 0.7,
      );
    }

    final pts = List.generate(n, (i) {
      final a = -pi / 2 + i * angleStep + t * pi * 2 * 0.02;
      final v = values[i];
      return Offset(cx + r * v * cos(a), cy + r * v * sin(a));
    });

    final fill = Path()..moveTo(pts.last.dx, pts.last.dy);
    for (final p in pts) fill.lineTo(p.dx, p.dy);
    fill.close();
    canvas.drawPath(
      fill,
      Paint()
        ..color = kAccent.withOpacity(0.08 + glowT * 0.04)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      fill,
      Paint()
        ..color = kAccent.withOpacity(0.6 + glowT * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawPath(
      fill,
      Paint()
        ..color = kAccent.withOpacity(0.2 + glowT * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    for (int i = 0; i < pts.length; i++) {
      final val = values[i];
      final col = val >= 0.7
          ? C.green
          : val >= 0.4
          ? C.amber
          : C.red;
      canvas.drawCircle(
        pts[i],
        4,
        Paint()
          ..color = col.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(pts[i], 2.5, Paint()..color = col);
    }

    for (int i = 0; i < n; i++) {
      final a = -pi / 2 + i * angleStep;
      final lx = cx + (r + 20) * cos(a);
      final ly = cy + (r + 20) * sin(a);
      final val = values[i];
      final col = val >= 0.7
          ? C.green
          : val >= 0.4
          ? C.amber
          : C.red;
      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: labels[i],
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: kAccent.withOpacity(0.6),
                letterSpacing: 1,
              ),
            ),
            TextSpan(
              text: '\n${(val * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: col,
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(RadarPainter o) => o.t != t || o.glowT != glowT;
}
