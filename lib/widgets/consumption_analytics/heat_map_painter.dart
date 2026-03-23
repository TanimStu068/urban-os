import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'dart:math';

class HeatmapPainter extends CustomPainter {
  final List<HourlyHeatmapCell> cells;
  final double glowT;
  const HeatmapPainter({required this.cells, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    const days = 7, hours = 24;
    const dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const padL = 30.0, padT = 12.0, padB = 18.0;

    final maxV = cells.map((c) => c.value).reduce(max);
    final cellW = (s.width - padL) / hours;
    final cellH = (s.height - padT - padB) / days;

    // Hour labels
    for (int h = 0; h < hours; h += 3) {
      final x = padL + h * cellW + cellW / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: '${h.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 3));
    }

    // Day labels
    for (int d = 0; d < days; d++) {
      final y = padT + d * cellH + cellH / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: dayLabels[d],
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padL - tp.width - 4, y - tp.height / 2));
    }

    for (final cell in cells) {
      final norm = (cell.value / maxV).clamp(0, 1);
      final x = padL + cell.hour * cellW;
      final y = padT + cell.day * cellH;

      Color cellColor;
      if (norm < 0.33) {
        cellColor = Color.lerp(C.bgCard2, C.teal, norm / 0.33)!;
      } else if (norm < 0.66) {
        cellColor = Color.lerp(C.teal, C.amber, (norm - 0.33) / 0.33)!;
      } else {
        cellColor = Color.lerp(C.amber, C.red, (norm - 0.66) / 0.34)!;
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1, y + 1, cellW - 2, cellH - 2),
          const Radius.circular(2),
        ),
        Paint()..color = cellColor.withOpacity(0.7 + norm * 0.25),
      );
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter o) => o.glowT != glowT;
}
