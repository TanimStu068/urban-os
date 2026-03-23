import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class RoadFlowPainter extends CustomPainter {
  final List<LiveVehicle> vehicles;
  final double flowT, pulseT, glowT;
  RoadFlowPainter({
    required this.vehicles,
    required this.flowT,
    required this.pulseT,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));

    // Grid
    final gp = Paint()
      ..color = kAccent.withOpacity(.03)
      ..strokeWidth = .3;
    for (double x = 0; x < s.width; x += 24)
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    for (double y = 0; y < s.height; y += 24)
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);

    // Road network lines (6 roads in the painter space)
    final roadLines = [
      // Horizontal
      [Offset(0, s.height * .22), Offset(s.width, s.height * .22)], // Ring Rd 4
      [
        Offset(0, s.height * .50),
        Offset(s.width, s.height * .50),
      ], // Industrial Blvd
      [
        Offset(0, s.height * .78),
        Offset(s.width, s.height * .78),
      ], // Freight F1
      // Vertical
      [Offset(s.width * .28, 0), Offset(s.width * .28, s.height)], // Gate Rd
      [
        Offset(s.width * .60, 0),
        Offset(s.width * .60, s.height),
      ], // North Access
      [
        Offset(s.width * .82, 0),
        Offset(s.width * .82, s.height),
      ], // South Bypass
    ];
    const roadCongestion = [88, 72, 61, 35, 91, 28];
    const roadColors = [C.red, C.amber, C.amber, C.green, C.red, C.green];

    for (int i = 0; i < roadLines.length; i++) {
      final pts = roadLines[i];
      final col = roadColors[i];
      // Road base
      canvas.drawLine(
        pts[0],
        pts[1],
        Paint()
          ..color = const Color(0xFF0A2035)
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
      // Congestion color
      canvas.drawLine(
        pts[0],
        pts[1],
        Paint()
          ..color = col.withOpacity(.5 + glowT * .1)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
      // Center line
      _drawDashed(canvas, pts[0], pts[1], C.white.withOpacity(.08));

      // Road label
      final mid = Offset(
        (pts[0].dx + pts[1].dx) / 2,
        (pts[0].dy + pts[1].dy) / 2,
      );
      final names = ['RD-04', 'RD-11', 'RD-18', 'RD-22', 'RD-27', 'RD-33'];
      final tp = TextPainter(
        text: TextSpan(
          text: names[i],
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: col.withOpacity(.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            mid.dx - tp.width / 2 - 3,
            mid.dy - tp.height / 2 - 2,
            tp.width + 6,
            tp.height + 4,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = C.bg.withOpacity(.85),
      );
      tp.paint(canvas, Offset(mid.dx - tp.width / 2, mid.dy - tp.height / 2));

      // Congestion %
      final cpct = roadCongestion[i];
      final ctp = TextPainter(
        text: TextSpan(
          text: '$cpct%',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: col.withOpacity(.8),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      ctp.paint(
        canvas,
        Offset(mid.dx - ctp.width / 2, mid.dy + tp.height / 2 + 1),
      );
    }

    // Intersection dots
    final intersections = [
      Offset(s.width * .28, s.height * .22),
      Offset(s.width * .60, s.height * .22),
      Offset(s.width * .82, s.height * .22),
      Offset(s.width * .28, s.height * .50),
      Offset(s.width * .60, s.height * .50),
      Offset(s.width * .28, s.height * .78),
    ];
    for (final pt in intersections) {
      canvas.drawCircle(
        pt,
        5 + pulseT * 2,
        Paint()
          ..color = kAccent.withOpacity(.06 + glowT * .04)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(pt, 4, Paint()..color = const Color(0xFF0A2035));
      canvas.drawCircle(
        pt,
        4,
        Paint()
          ..color = kAccent.withOpacity(.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      canvas.drawCircle(pt, 2, Paint()..color = kAccent.withOpacity(.8));
    }

    // Vehicles moving along roads
    for (final v in vehicles) {
      if (v.laneIdx >= roadLines.length) continue;
      final pts = roadLines[v.laneIdx];
      final pos = Offset(
        pts[0].dx + (pts[1].dx - pts[0].dx) * v.progress,
        pts[0].dy + (pts[1].dy - pts[0].dy) * v.progress,
      );
      canvas.drawCircle(
        pos,
        3.5,
        Paint()
          ..color = v.color.withOpacity(.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawCircle(pos, 2, Paint()..color = v.color);
      // Trail
      final prev = Offset(
        pts[0].dx + (pts[1].dx - pts[0].dx) * (v.progress - .015).clamp(0, 1),
        pts[0].dy + (pts[1].dy - pts[0].dy) * (v.progress - .015).clamp(0, 1),
      );
      canvas.drawLine(
        pos,
        prev,
        Paint()
          ..color = v.color.withOpacity(.3)
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawDashed(Canvas canvas, Offset a, Offset b, Color col) {
    final dir = (b - a) / (b - a).distance;
    final len = (b - a).distance;
    double pos = 6;
    while (pos < len - 6) {
      canvas.drawLine(
        a + dir * pos,
        a + dir * (pos + 5),
        Paint()
          ..color = col
          ..strokeWidth = .8
          ..strokeCap = StrokeCap.round,
      );
      pos += 11;
    }
  }

  @override
  bool shouldRepaint(RoadFlowPainter o) =>
      o.flowT != flowT || o.pulseT != pulseT || o.glowT != glowT;
}
