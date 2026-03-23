import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';

typedef C = AppColors;

class LaneVisPainter extends CustomPainter {
  final List<LaneInfo> lanes;
  final double progress, glowT;
  LaneVisPainter({
    required this.lanes,
    required this.progress,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final laneW = (s.width - 16) / lanes.length;
    for (int i = 0; i < lanes.length; i++) {
      final l = lanes[i];
      final col = _c(l.congestion);
      final x = 8 + i * laneW;
      final barMaxH = s.height - 28;
      final barH = barMaxH * l.congestion * progress;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 4, 8, laneW - 8, barMaxH),
          const Radius.circular(4),
        ),
        Paint()..color = col.withOpacity(0.1),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 4, 8 + barMaxH - barH, laneW - 8, barH),
          const Radius.circular(4),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [col.withOpacity(0.7), col.withOpacity(0.3 + glowT * 0.1)],
          ).createShader(Rect.fromLTWH(x + 4, 8, laneW - 8, barMaxH)),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 4, 8 + barMaxH - barH, laneW - 8, barH),
          const Radius.circular(4),
        ),
        Paint()
          ..color = col.withOpacity(0.15 + glowT * 0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: 'L${l.laneNum}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: col.withOpacity(0.8),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + (laneW - tp.width) / 2, s.height - 16));

      final pp = TextPainter(
        text: TextSpan(
          text: '${(l.congestion * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: col.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      pp.paint(
        canvas,
        Offset(x + (laneW - pp.width) / 2, 8 + barMaxH - barH - 14),
      );
    }
  }

  Color _c(double v) => v >= 0.85
      ? C.red
      : v >= 0.6
      ? C.amber
      : C.green;

  @override
  bool shouldRepaint(LaneVisPainter o) =>
      o.progress != progress || o.glowT != glowT;
}
