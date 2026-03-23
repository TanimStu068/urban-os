import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'dart:math';

class SeverityDonutPainter extends CustomPainter {
  final List<AccidentEvent> accidents;
  final double glowT;
  SeverityDonutPainter({required this.accidents, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    final counts = <AccidentSeverity, int>{};
    for (final a in accidents) {
      counts[a.severity] = (counts[a.severity] ?? 0) + 1;
    }
    final total = accidents.length.toDouble();
    final cx = s.width * .38, cy = s.height / 2, r = min(cx, cy) - 8;

    double start = -pi / 2;
    for (final sev in AccidentSeverity.values) {
      final count = counts[sev] ?? 0;
      if (count == 0) continue;
      final sweep = (count / total) * 2 * pi;
      final col = sev.color;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep - 0.04,
        false,
        Paint()
          ..color = col
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.butt,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep - 0.04,
        false,
        Paint()
          ..color = col.withOpacity(0.25 + glowT * 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.butt
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      start += sweep;
    }
    canvas.drawCircle(Offset(cx, cy), r - 22, Paint()..color = C.bgCard);

    // Center text
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${accidents.length}\n',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: C.red,
              shadows: [Shadow(color: C.red.withOpacity(0.5), blurRadius: 8)],
            ),
          ),
          const TextSpan(
            text: 'TOTAL',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
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

    // Legend on the right
    double ly = s.height / 2 - (AccidentSeverity.values.length * 18) / 2;
    for (final sev in AccidentSeverity.values) {
      final count = counts[sev] ?? 0;
      final ltp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$count  ',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: sev.color,
              ),
            ),
            TextSpan(
              text: sev.label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: sev.color.withOpacity(0.7),
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.drawCircle(
        Offset(s.width * .62, ly + 6),
        4,
        Paint()..color = sev.color.withOpacity(0.8),
      );
      ltp.paint(canvas, Offset(s.width * .62 + 10, ly));
      ly += 20;
    }
  }

  @override
  bool shouldRepaint(SeverityDonutPainter o) => o.glowT != glowT;
}
