import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/district_map_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_type.dart';

typedef _TileColorFn = Color Function(MapMode, DistrictModel);
typedef _TileFracFn = double Function(MapMode, DistrictModel);

class CityMapPainter extends CustomPainter {
  final List<MapTile> tiles;
  final MapMode mode;
  final DistrictModel? selected;
  final double scale, glowT, pulseT, blinkT;
  final Offset pan;
  final _TileColorFn tileColorFn;
  final _TileFracFn tileFracFn;

  CityMapPainter({
    required this.tiles,
    required this.mode,
    required this.selected,
    required this.scale,
    required this.pan,
    required this.glowT,
    required this.pulseT,
    required this.blinkT,
    required this.tileColorFn,
    required this.tileFracFn,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    canvas.save();
    canvas.translate(cx + pan.dx, cy + pan.dy);
    canvas.scale(scale);
    canvas.translate(-cx, -cy);

    for (final tile in tiles) {
      final d = tile.district;
      final r = tile.rect;
      final col = tileColorFn(mode, d);
      final frac = tileFracFn(mode, d);
      final isSelected = selected?.id == d.id;
      final isCritical = d.metrics.hasCriticalIssues;

      // Shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(r.inflate(3), const Radius.circular(10)),
        Paint()
          ..color = col.withOpacity(0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      // Fill base
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(8)),
        Paint()..color = AppColors.bgCard.withOpacity(0.85),
      );

      // Health fill overlay (bottom-up)
      final fillRect = Rect.fromLTWH(
        r.left,
        r.bottom - r.height * frac,
        r.width,
        r.height * frac,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          fillRect,
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8),
        ),
        Paint()..color = col.withOpacity(0.18),
      );

      // Border
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(8)),
        Paint()
          ..color = isSelected
              ? col.withOpacity(0.8 + glowT * 0.15)
              : isCritical
              ? AppColors.red.withOpacity(0.5 + blinkT * 0.2)
              : col.withOpacity(0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2 : 1.2,
      );

      // Selected glow
      if (isSelected) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(r.inflate(3), const Radius.circular(10)),
          Paint()
            ..color = col.withOpacity(0.12 + glowT * 0.08)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
      }

      // Critical pulse ring
      if (isCritical) {
        final pulse = r.inflate(3 + pulseT * 5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(pulse, const Radius.circular(12)),
          Paint()
            ..color = AppColors.red.withOpacity(0.2 * (1 - pulseT))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }

      // District name
      final nameTP = TextPainter(
        text: TextSpan(
          text: d.name.length > 14 ? '${d.name.substring(0, 12)}…' : d.name,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: AppColors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r.width - 8);
      nameTP.paint(canvas, Offset(r.left + 6, r.top + 7));

      // Type label
      final typeTP = TextPainter(
        text: TextSpan(
          text: d.type.displayName,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: col.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r.width - 8);
      typeTP.paint(canvas, Offset(r.left + 6, r.top + 20));

      // Health value (Orbitron-style)
      final scoreTP = TextPainter(
        text: TextSpan(
          text: '${d.healthPercentage.toInt()}',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 16,
            color: col,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      scoreTP.paint(
        canvas,
        Offset(r.right - scoreTP.width - 7, r.bottom - scoreTP.height - 5),
      );

      // Incident badge
      if (d.metrics.activeIncidents > 0) {
        final br = Offset(r.right - 10, r.top + 10);
        canvas.drawCircle(
          br,
          9,
          Paint()..color = AppColors.red.withOpacity(0.9),
        );
        final incTP = TextPainter(
          text: TextSpan(
            text: '${d.metrics.activeIncidents}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        incTP.paint(
          canvas,
          Offset(br.dx - incTP.width / 2, br.dy - incTP.height / 2),
        );
      }

      // Sensor count
      final sensTP = TextPainter(
        text: TextSpan(
          text: '●${d.sensorCount}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: AppColors.cyan.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      sensTP.paint(canvas, Offset(r.left + 6, r.bottom - sensTP.height - 5));
    }

    canvas.restore();

    // ── Legend overlay (in screen space) ──
    _drawLegend(canvas, s);
    // ── Scale bar ──
    _drawScaleBar(canvas, s);
  }

  void _drawLegend(Canvas canvas, Size s) {
    final entries = mode == MapMode.type
        ? [
            ('COMMERCIAL', AppColors.amber),
            ('RESIDENTIAL', AppColors.cyan),
            ('INDUSTRIAL', AppColors.mutedLt),
            ('GREEN ZONE', AppColors.green),
            ('MEDICAL', AppColors.red),
            ('GOVT/EDU', AppColors.violet),
          ]
        : [
            ('HIGH (≥70)', AppColors.green),
            ('MEDIUM (45–70)', AppColors.amber),
            ('LOW (<45)', AppColors.red),
          ];

    const startX = 12.0;
    final startY = s.height - 14.0 - entries.length * 14.0;

    // Background
    final bgRect = Rect.fromLTWH(
      startX - 4,
      startY - 6,
      130,
      entries.length * 14.0 + 10,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      Paint()..color = AppColors.bgCard.withOpacity(0.8),
    );

    for (int i = 0; i < entries.length; i++) {
      final y = startY + i * 14.0;
      canvas.drawCircle(
        Offset(startX + 5, y + 4),
        4,
        Paint()..color = entries[i].$2,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: entries[i].$1,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: entries[i].$2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(startX + 14, y));
    }
  }

  void _drawScaleBar(Canvas canvas, Size s) {
    // Display current scale factor in corner
    final tp = TextPainter(
      text: TextSpan(
        text: '${(scale * 100).toInt()}%',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 8,
          color: AppColors.mutedLt,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(s.width - tp.width - 12, s.height - 20));
  }

  @override
  bool shouldRepaint(CityMapPainter old) =>
      old.selected?.id != selected?.id ||
      old.glowT != glowT ||
      old.pulseT != pulseT ||
      old.blinkT != blinkT ||
      old.scale != scale ||
      old.pan != pan ||
      old.mode != mode;
}
