import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';

class RiskHeatmapPainter extends CustomPainter {
  final List<RiskZone> zones;
  final double progress;
  final double pulse;
  RiskHeatmapPainter(this.zones, this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final n = zones.length;
    final cellW = size.width / 3;
    final cellH = size.height / 2;

    for (int i = 0; i < n && i < 6; i++) {
      final z = zones[i];
      final row = i ~/ 3;
      final col = i % 3;
      final rect = Rect.fromLTWH(
        col * cellW + 2,
        row * cellH + 2,
        cellW - 4,
        cellH - 4,
      );

      final riskCol = z.score > 0.8
          ? AppColors.red
          : z.score > 0.55
          ? AppColors.amber
          : AppColors.green;

      final fillOpacity = (z.score * 0.3 * progress);
      final pulseBoost = z.score > 0.8 ? pulse * 0.06 : 0.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()..color = riskCol.withOpacity(fillOpacity + pulseBoost),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()
          ..color = riskCol.withOpacity(0.35 + pulseBoost)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // District label
      final tp = TextPainter(
        text: TextSpan(
          text: z.district,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: riskCol,
            letterSpacing: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(rect.center.dx - tp.width / 2, rect.top + 8));

      // Score
      final sp = TextPainter(
        text: TextSpan(
          text: '${(z.score * 100).round()}',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 18,
            color: riskCol,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      sp.paint(
        canvas,
        Offset(
          rect.center.dx - sp.width / 2,
          rect.center.dy - sp.height / 2 + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(RiskHeatmapPainter old) =>
      old.progress != progress || old.pulse != pulse;
}
