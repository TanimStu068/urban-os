import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';

typedef C = AppColors;

const kAccent = C.teal;

class CityMapPainter extends CustomPainter {
  final List<AccidentEvent> accidents;
  final String selectedId;
  final double waveT;
  final double pulseT;
  final double glowT;

  CityMapPainter({
    required this.accidents,
    required this.selectedId,
    required this.waveT,
    required this.pulseT,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGrid(canvas, size);
    _drawRoads(canvas, size);
    _drawAccidents(canvas, size);
    _drawLegend(canvas, size);
  }

  // ─────────────────────────────
  // Background
  // ─────────────────────────────
  void _drawBackground(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));
  }

  // ─────────────────────────────
  // Grid
  // ─────────────────────────────
  void _drawGrid(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = kAccent.withOpacity(0.025)
      ..strokeWidth = 0.3;

    for (double x = 0; x < s.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), paint);
    }

    for (double y = 0; y < s.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), paint);
    }
  }

  // ─────────────────────────────
  // Roads
  // ─────────────────────────────
  void _drawRoads(Canvas canvas, Size s) {
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
      // Base road
      canvas.drawLine(
        r.$1,
        r.$2,
        Paint()
          ..color = const Color(0xFF0A1E30)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );

      // Glow overlay
      canvas.drawLine(
        r.$1,
        r.$2,
        Paint()
          ..color = r.$3.withOpacity(0.3 + glowT * 0.1)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // ─────────────────────────────
  // Accident Pins
  // ─────────────────────────────
  void _drawAccidents(Canvas canvas, Size s) {
    for (final acc in accidents) {
      final x = acc.mapX * s.width;
      final y = acc.mapY * s.height;

      final color = acc.severity.color;
      final isSelected = acc.id == selectedId;
      final isActive = acc.severity != AccidentSeverity.cleared;

      final center = Offset(x, y);

      // ── Wave animation ──
      if (isActive) {
        for (int i = 0; i < 3; i++) {
          final progress = ((waveT + i * 0.33) % 1.0);
          final radius = 8.0 + progress * 28;

          canvas.drawCircle(
            center,
            radius,
            Paint()
              ..color = color.withOpacity((1 - progress) * 0.25)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );
        }
      }

      // ── Glow ──
      canvas.drawCircle(
        center,
        isSelected ? 12 : 8,
        Paint()
          ..color = color.withOpacity(0.2 + glowT * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // ── Main circle ──
      final radius = isSelected ? 9.0 : 6.0;

      canvas.drawCircle(center, radius, Paint()..color = color);

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2 : 1.2,
      );

      // ── Inner dot ──
      canvas.drawCircle(
        center,
        isSelected ? 3.5 : 2.5,
        Paint()..color = Colors.white,
      );

      // ── Label ──
      _drawLabel(canvas, center, acc, isSelected, color);
    }
  }

  // ─────────────────────────────
  // Label
  // ─────────────────────────────
  void _drawLabel(
    Canvas canvas,
    Offset center,
    AccidentEvent acc,
    bool isSelected,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: acc.id.replaceAll('ACC-', ''),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: isSelected ? 7.5 : 6.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offsetY = isSelected ? 12 : 8;

    final rect = Rect.fromLTWH(
      center.dx - textPainter.width / 2 - 3,
      center.dy + offsetY,
      textPainter.width + 6,
      textPainter.height + 4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = C.bg.withOpacity(0.85),
    );

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + offsetY + 1),
    );
  }

  // ─────────────────────────────
  // Legend
  // ─────────────────────────────
  void _drawLegend(Canvas canvas, Size s) {
    final items = [
      ('CRITICAL', C.red),
      ('HIGH', C.orange),
      ('MEDIUM', C.amber),
      ('CLEARED', C.green),
    ];

    double x = 8;

    for (final item in items) {
      canvas.drawCircle(
        Offset(x + 4, s.height - 10),
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

      tp.paint(canvas, Offset(x + 11, s.height - 14));

      x += tp.width + 20;
    }
  }

  // ─────────────────────────────
  // Repaint Logic
  // ─────────────────────────────
  @override
  bool shouldRepaint(covariant CityMapPainter oldDelegate) {
    return oldDelegate.waveT != waveT ||
        oldDelegate.pulseT != pulseT ||
        oldDelegate.glowT != glowT ||
        oldDelegate.selectedId != selectedId ||
        oldDelegate.accidents != accidents;
  }
}
