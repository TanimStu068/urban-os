import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'dart:math';

class DonutPainter extends CustomPainter {
  final List<EnergySourceModel> sources;
  final double glowT;
  final bool compact;

  DonutPainter({
    required this.sources,
    required this.glowT,
    this.compact = false,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final total = sources
        .where((src) => src.isActive)
        .fold(0.0, (sum, src) => sum + src.output);
    if (total == 0) return;

    final center = Offset(s.width / 2, s.height / 2);
    final radius = min(s.width, s.height) / 2 - 8;
    final thickness = compact ? 10.0 : 18.0;

    double startAngle = -pi / 2;
    for (final src in sources) {
      if (!src.isActive || src.output == 0) continue;
      final sweep = (src.output / total) * 2 * pi;

      // Glow
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = src.type.color.withOpacity(0.2 + glowT * 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness + 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // Fill
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = src.type.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
      );

      startAngle += sweep;
    }

    if (!compact) {
      // Center text
      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${(total / 1000).toStringAsFixed(1)}\n',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: C.amber,
              ),
            ),
            const TextSpan(
              text: 'MW',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.muted,
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(
        canvas,
        Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(DonutPainter o) =>
      o.glowT != glowT || o.sources.length != sources.length;
}
