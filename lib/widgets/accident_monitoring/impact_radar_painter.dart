import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

class ImpactRadarPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double t, glowT;
  ImpactRadarPainter({
    required this.values,
    required this.color,
    required this.t,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = min(cx, cy) - 36;
    const n = 6;
    const angleStep = 2 * pi / n;
    final labels = [
      'ROAD\nIMPACT',
      'INJURY\nRISK',
      'TRAFFIC\nBLOCK',
      'RESPONSE\nURGENCY',
      'PROPERTY\nDAMAGE',
      'NETWORK\nDISRUPT',
    ];

    // Rings
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
          ..color = C.red.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    // Spokes
    for (int i = 0; i < n; i++) {
      final a = -pi / 2 + i * angleStep;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + r * cos(a), cy + r * sin(a)),
        Paint()
          ..color = C.red.withOpacity(0.1)
          ..strokeWidth = 0.7,
      );
    }

    // Data polygon
    final pts = List.generate(n, (i) {
      final a = -pi / 2 + i * angleStep + t * pi * 2 * 0.015;
      return Offset(cx + r * values[i] * cos(a), cy + r * values[i] * sin(a));
    });

    final fill = Path()..moveTo(pts.last.dx, pts.last.dy);
    for (final p in pts) fill.lineTo(p.dx, p.dy);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()..color = color.withOpacity(0.1 + glowT * 0.05),
    );
    canvas.drawPath(
      fill,
      Paint()
        ..color = color.withOpacity(0.25 + glowT * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(
      fill,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Dots + value labels
    for (int i = 0; i < pts.length; i++) {
      final v = values[i];
      final dot = pts[i];
      final dCol = v > 0.7
          ? C.red
          : v > 0.4
          ? C.amber
          : C.green;
      canvas.drawCircle(
        dot,
        5,
        Paint()
          ..color = dCol.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(dot, 3, Paint()..color = dCol);

      // Axis label
      final a = -pi / 2 + i * angleStep;
      final lx = cx + (r + 26) * cos(a);
      final ly = cy + (r + 26) * sin(a);
      final lbl = labels[i];
      final lines = lbl.split('\n');
      double textY = ly - lines.length * 5.0;
      for (final line in lines) {
        final tp = TextPainter(
          text: TextSpan(
            text: line,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: color.withOpacity(0.6),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(lx - tp.width / 2, textY));
        textY += 10;
      }
      // Value
      final vtp = TextPainter(
        text: TextSpan(
          text: '${(v * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            color: dCol,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      vtp.paint(
        canvas,
        Offset(lx - vtp.width / 2, ly + (lbl.split('\n').length) * 10 - 4),
      );
    }
  }

  @override
  bool shouldRepaint(ImpactRadarPainter o) => o.t != t || o.glowT != glowT;
}
