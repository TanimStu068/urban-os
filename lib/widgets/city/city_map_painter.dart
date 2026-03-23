import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';

typedef C = AppColors;

class CityMapPainter extends CustomPainter {
  final List<AccidentEvent> accidents;
  final String selectedId;
  final double waveT, pulseT, glowT;

  CityMapPainter({
    required this.accidents,
    required this.selectedId,
    required this.waveT,
    required this.pulseT,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));

    // Grid
    final gp = Paint()
      ..color = kAccent.withOpacity(0.025)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 20)
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    for (double y = 0; y < s.height; y += 20)
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);

    // Schematic road network
    final roads = [
      // Horizontal
      (Offset(0, s.height * .28), Offset(s.width, s.height * .28), C.red),
      (Offset(0, s.height * .52), Offset(s.width, s.height * .52), C.amber),
      (Offset(0, s.height * .74), Offset(s.width, s.height * .74), C.amber),
      // Vertical
      (Offset(s.width * .30, 0), Offset(s.width * .30, s.height), C.green),
      (Offset(s.width * .62, 0), Offset(s.width * .62, s.height), C.red),
      (Offset(s.width * .82, 0), Offset(s.width * .82, s.height), C.green),
    ];

    for (final r in roads) {
      canvas.drawLine(
        r.$1,
        r.$2,
        Paint()
          ..color = const Color(0xFF0A1E30)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(
        r.$1,
        r.$2,
        Paint()
          ..color = r.$3.withOpacity(0.3 + glowT * 0.1)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    // Incident pins
    for (final acc in accidents) {
      final x = acc.mapX * s.width;
      final y = acc.mapY * s.height;
      final col = acc.severity.color;
      final isSel = acc.id == selectedId;
      final isActive = acc.severity != AccidentSeverity.cleared;

      // Wave rings for active incidents
      if (isActive) {
        for (int w = 0; w < 3; w++) {
          final waveProgress = ((waveT + w * 0.33) % 1.0);
          final r = 8.0 + waveProgress * 28;
          canvas.drawCircle(
            Offset(x, y),
            r,
            Paint()
              ..color = col.withOpacity((1 - waveProgress) * 0.25)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );
        }
      }

      // Outer glow
      canvas.drawCircle(
        Offset(x, y),
        isSel ? 12 : 8,
        Paint()
          ..color = col.withOpacity(0.2 + glowT * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Pin body
      canvas.drawCircle(
        Offset(x, y),
        isSel ? 9 : 6,
        Paint()..color = col.withOpacity(0.9),
      );
      canvas.drawCircle(
        Offset(x, y),
        isSel ? 9 : 6,
        Paint()
          ..color = col.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSel ? 2 : 1.2,
      );

      // Inner dot
      canvas.drawCircle(
        Offset(x, y),
        isSel ? 3.5 : 2.5,
        Paint()..color = Colors.white.withOpacity(0.9),
      );

      // ID label
      final tp = TextPainter(
        text: TextSpan(
          text: acc.id.substring(4), // e.g. '2041'
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: isSel ? 7.5 : 6.5,
            fontWeight: FontWeight.w700,
            color: col,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - tp.width / 2 - 3,
            y + (isSel ? 12 : 8),
            tp.width + 6,
            tp.height + 4,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = C.bg.withOpacity(0.85),
      );
      tp.paint(canvas, Offset(x - tp.width / 2, y + (isSel ? 13 : 9)));
    }

    // Legend
    final legendItems = [
      ('CRITICAL', C.red),
      ('HIGH', C.orange),
      ('MEDIUM', C.amber),
      ('CLEARED', C.green),
    ];
    double lx = 8;
    for (final item in legendItems) {
      canvas.drawCircle(
        Offset(lx + 4, s.height - 10),
        4,
        Paint()..color = item.$2.withOpacity(0.8),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: item.$1,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: item.$2.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx + 11, s.height - 14));
      lx += tp.width + 20;
    }
  }

  @override
  bool shouldRepaint(CityMapPainter o) =>
      o.waveT != waveT || o.glowT != glowT || o.selectedId != selectedId;
}
