import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/live_dot.dart';

class RoadTopologyPainter extends CustomPainter {
  final RoadDetailData road;
  final List<LiveDot> dots;
  final double pulseT, glowT, blinkT;
  RoadTopologyPainter({
    required this.road,
    required this.dots,
    required this.pulseT,
    required this.glowT,
    required this.blinkT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));

    final gp = Paint()
      ..color = kAccent.withOpacity(0.025)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 20)
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    for (double y = 0; y < s.height; y += 20)
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);

    final numLanes = road.lanes;
    const laneH = 22.0;
    final roadH = numLanes * laneH + 24;
    final roadTop = (s.height - roadH) / 2;
    const padX = 40.0;

    canvas.drawRect(
      Rect.fromLTWH(padX, roadTop, s.width - padX * 2, roadH),
      Paint()..color = const Color(0xFF0A1E30),
    );
    canvas.drawRect(
      Rect.fromLTWH(padX, roadTop, s.width - padX * 2, roadH),
      Paint()
        ..color = kAccent.withOpacity(0.04 + glowT * 0.02)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    for (int i = 0; i < numLanes; i++) {
      final laneTop = roadTop + 12 + i * laneH;
      final lane = road.laneInfo[i];
      final col = _congCol(lane.congestion);

      canvas.drawRect(
        Rect.fromLTWH(
          padX + 2,
          laneTop + 1,
          (s.width - padX * 2 - 4) * lane.congestion,
          laneH - 2,
        ),
        Paint()..color = col.withOpacity(0.12 + glowT * 0.04),
      );

      if (i > 0) {
        _drawDashedH(
          canvas,
          Offset(padX, laneTop),
          Offset(s.width - padX, laneTop),
          C.white.withOpacity(0.06),
        );
      }

      final arrowX = padX + 10;
      final arrowY = laneTop + laneH / 2;
      final dir = lane.isReverse ? -1.0 : 1.0;
      canvas.drawLine(
        Offset(arrowX, arrowY),
        Offset(arrowX + dir * 10, arrowY),
        Paint()
          ..color = col.withOpacity(0.5)
          ..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(arrowX + dir * 10, arrowY),
        Offset(arrowX + dir * 6, arrowY - 3),
        Paint()
          ..color = col.withOpacity(0.5)
          ..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(arrowX + dir * 10, arrowY),
        Offset(arrowX + dir * 6, arrowY + 3),
        Paint()
          ..color = col.withOpacity(0.5)
          ..strokeWidth = 1.5,
      );

      _paintText(
        canvas,
        'L${i + 1}',
        Offset(padX - 22, arrowY - 4.5),
        7,
        col.withOpacity(0.7),
      );
    }

    canvas.drawLine(
      Offset(padX, roadTop + 12),
      Offset(s.width - padX, roadTop + 12),
      Paint()
        ..color = C.amber.withOpacity(0.4)
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(padX, roadTop + roadH - 12),
      Offset(s.width - padX, roadTop + roadH - 12),
      Paint()
        ..color = C.amber.withOpacity(0.4)
        ..strokeWidth = 1.5,
    );

    for (final inc in road.activeIncidents) {
      final incX = padX + (s.width - padX * 2) * inc.position;
      canvas.drawCircle(
        Offset(incX, roadTop - 14),
        6 + pulseT * 4,
        Paint()
          ..color = inc.color.withOpacity(0.15 * (1 - pulseT))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(
        Offset(incX, roadTop - 14),
        5,
        Paint()..color = inc.color,
      );
      canvas.drawLine(
        Offset(incX, roadTop - 9),
        Offset(incX, roadTop + 12),
        Paint()
          ..color = inc.color.withOpacity(0.5)
          ..strokeWidth = 1,
      );
      _paintText(
        canvas,
        inc.type,
        Offset(incX - 14, roadTop - 28),
        6,
        inc.color,
      );
    }

    for (final dot in dots) {
      if (dot.lane >= numLanes) continue;
      final laneTop = roadTop + 12 + dot.lane * laneH;
      final dotX = padX + (s.width - padX * 2) * dot.progress;
      final dotY = laneTop + laneH / 2;
      canvas.drawCircle(
        Offset(dotX, dotY),
        4,
        Paint()
          ..color = dot.color.withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(Offset(dotX, dotY), 2, Paint()..color = dot.color);
      final trailX = dot.isReverse
          ? (dotX + 12).clamp(padX, s.width - padX)
          : (dotX - 12).clamp(padX, s.width - padX);
      canvas.drawLine(
        Offset(dotX, dotY),
        Offset(trailX.toDouble(), dotY),
        Paint()
          ..color = dot.color.withOpacity(0.25)
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round,
      );
    }

    final totalKm = road.length / 1000.0;
    for (int k = 0; k <= totalKm.floor(); k++) {
      final x = padX + (s.width - padX * 2) * (k / totalKm);
      canvas.drawLine(
        Offset(x, roadTop + roadH - 12),
        Offset(x, roadTop + roadH),
        Paint()
          ..color = kAccent.withOpacity(0.3)
          ..strokeWidth = 0.8,
      );
      _paintText(
        canvas,
        '${k}km',
        Offset(x - 8, roadTop + roadH + 3),
        6,
        kAccent.withOpacity(0.4),
      );
    }
  }

  void _drawDashedH(Canvas canvas, Offset a, Offset b, Color col) {
    double x = a.dx;
    while (x < b.dx - 5) {
      canvas.drawLine(
        Offset(x, a.dy),
        Offset(x + 5, a.dy),
        Paint()
          ..color = col
          ..strokeWidth = 0.7
          ..strokeCap = StrokeCap.round,
      );
      x += 10;
    }
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset pos,
    double size,
    Color col,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontFamily: 'monospace', fontSize: size, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  Color _congCol(double c) => c >= 0.85
      ? C.red
      : c >= 0.6
      ? C.amber
      : C.green;

  @override
  bool shouldRepaint(RoadTopologyPainter o) =>
      o.pulseT != pulseT || o.glowT != glowT;
}

extension on LaneInfo {
  bool get isReverse =>
      direction == 'SW' || direction == 'W' || direction == 'S';
}
