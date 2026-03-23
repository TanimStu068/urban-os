import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';

class SpeedZoneMapPainter extends CustomPainter {
  final List<SpeedZone> zones;
  final double totalKm, glowT;
  SpeedZoneMapPainter({
    required this.zones,
    required this.totalKm,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const padX = 40.0, roadH = 18.0;
    final roadY = (s.height - roadH) / 2;
    final roadW = s.width - padX * 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(padX, roadY, roadW, roadH),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF0A1E30),
    );

    for (final z in zones) {
      final x = padX + (z.startKm / totalKm) * roadW;
      final w = ((z.endKm - z.startKm) / totalKm) * roadW;
      final isCritical = z.currentSpeed < z.limit * 0.5;
      final col = isCritical
          ? C.red
          : z.currentSpeed < z.limit * 0.75
          ? C.amber
          : C.green;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1, roadY + 1, w - 2, roadH - 2),
          const Radius.circular(3),
        ),
        Paint()..color = col.withOpacity(0.25 + glowT * 0.05),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: '${z.currentSpeed}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            color: col,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      if (w > tp.width + 4) {
        tp.paint(
          canvas,
          Offset(x + (w - tp.width) / 2, roadY + (roadH - tp.height) / 2),
        );
      }

      _paintTxt(
        canvas,
        '${z.startKm.toStringAsFixed(1)}',
        Offset(x - 4, roadY + roadH + 4),
        6,
        kAccent.withOpacity(0.35),
      );
    }
    _paintTxt(
      canvas,
      '${totalKm.toStringAsFixed(1)}km',
      Offset(padX + roadW - 14, roadY + roadH + 4),
      6,
      kAccent.withOpacity(0.35),
    );
  }

  void _paintTxt(Canvas canvas, String t, Offset pos, double sz, Color col) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(SpeedZoneMapPainter o) => o.glowT != glowT;
}
