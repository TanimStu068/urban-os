import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'dart:math';

class DonutPainter extends CustomPainter {
  final ParkingLot lot;
  final int liveOcc;
  final double glowT, pulseT;
  DonutPainter({
    required this.lot,
    required this.liveOcc,
    required this.glowT,
    required this.pulseT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = min(cx, cy) - 6;
    final total = lot.totalSpaces.toDouble();
    final occRate = liveOcc / total;
    final resRate = lot.reserved / total;
    final avRate = (total - liveOcc - lot.reserved) / total;

    // Background ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = C.muted.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14,
    );

    // Available arc
    _drawArc(canvas, cx, cy, r, -pi / 2, avRate * 2 * pi, C.green, 14, glowT);
    // Reserved arc
    _drawArc(
      canvas,
      cx,
      cy,
      r,
      -pi / 2 + avRate * 2 * pi,
      resRate * 2 * pi,
      C.violet,
      14,
      glowT,
    );
    // Occupied arc
    _drawArc(
      canvas,
      cx,
      cy,
      r,
      -pi / 2 + (avRate + resRate) * 2 * pi,
      occRate * 2 * pi,
      lot.status.color,
      14,
      glowT,
    );

    // Center
    canvas.drawCircle(Offset(cx, cy), r - 20, Paint()..color = C.bgCard);
    // Pulse ring
    canvas.drawCircle(
      Offset(cx, cy),
      r - 18 + pulseT * 3,
      Paint()
        ..color = lot.status.color.withOpacity(0.05 * (1 - pulseT))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Text
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${(occRate * 100).toStringAsFixed(0)}%\n',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: lot.status.color,
              shadows: [
                Shadow(color: lot.status.color.withOpacity(0.5), blurRadius: 8),
              ],
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

  void _drawArc(
    Canvas c,
    double cx,
    double cy,
    double r,
    double start,
    double sweep,
    Color col,
    double w,
    double glowT,
  ) {
    if (sweep <= 0) return;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    c.drawArc(
      rect,
      start,
      sweep - 0.03,
      false,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..strokeCap = StrokeCap.butt,
    );
    c.drawArc(
      rect,
      start,
      sweep - 0.03,
      false,
      Paint()
        ..color = col.withOpacity(0.25 + glowT * 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w + 6
        ..strokeCap = StrokeCap.butt
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(DonutPainter o) =>
      o.liveOcc != liveOcc || o.glowT != glowT || o.pulseT != pulseT;
}
