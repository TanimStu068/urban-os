import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';

class CongestionBarPainter extends CustomPainter {
  final List<RoadSegment> roads;
  final double glowT;
  CongestionBarPainter({required this.roads, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    final total = roads.length;
    final barH = 14.0;
    final gap = (s.height - total * barH) / (total + 1);

    for (int i = 0; i < total; i++) {
      final r = roads[i];
      final y = gap * (i + 1) + barH * i;
      final barW = (r.congestion / 100) * (s.width - 70);
      final col = r.color;

      // Track
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60, y, s.width - 70, barH),
          const Radius.circular(3),
        ),
        Paint()..color = col.withOpacity(.08),
      );
      // Fill
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60, y, barW, barH),
          const Radius.circular(3),
        ),
        Paint()
          ..shader = LinearGradient(
            colors: [col.withOpacity(.5), col.withOpacity(.85 + glowT * .1)],
          ).createShader(Rect.fromLTWH(60, y, barW, barH)),
      );
      // Glow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(60, y, barW, barH),
          const Radius.circular(3),
        ),
        Paint()
          ..color = col.withOpacity(.15 + glowT * .06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: r.id,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: col.withOpacity(.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y + barH / 2 - tp.height / 2));
      // %
      final vtp = TextPainter(
        text: TextSpan(
          text: '${r.congestion}%',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: col,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      vtp.paint(canvas, Offset(60 + barW + 4, y + barH / 2 - vtp.height / 2));
    }
  }

  @override
  bool shouldRepaint(CongestionBarPainter o) => o.glowT != glowT;
}
