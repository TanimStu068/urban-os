import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'dart:math';

typedef C = AppColors;

class DonutPainter extends CustomPainter {
  final List<CategoryData> categories;
  final double animT, glowT;
  const DonutPainter({
    required this.categories,
    required this.animT,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final center = Offset(s.width / 2, s.height / 2);
    final r = min(s.width, s.height) / 2 - 14;
    const thickness = 22.0;
    double start = -pi / 2;
    final total = categories.fold(0.0, (s, c) => s + c.pct);
    for (final cat in categories) {
      final sweep = (cat.pct / total) * 2 * pi * animT;
      // glow
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start,
        sweep,
        false,
        Paint()
          ..color = cat.color.withOpacity(0.18 + glowT * 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness + 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      // arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start,
        sweep,
        false,
        Paint()
          ..color = cat.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
    // Center
    final tp = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'ENERGY\n',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: C.muted,
              letterSpacing: 1,
            ),
          ),
          TextSpan(
            text: 'MIX',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: C.amber,
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

  @override
  bool shouldRepaint(DonutPainter o) => o.animT != animT || o.glowT != glowT;
}
