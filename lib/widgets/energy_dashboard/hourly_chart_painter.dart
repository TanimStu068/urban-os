import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'dart:math';

class HourlyChartPainter extends CustomPainter {
  final List<HourlyData> data;
  final double glowT;

  HourlyChartPainter({required this.data, required this.glowT});

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    const padL = 8.0, padR = 8.0, padT = 8.0, padB = 18.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;

    final maxCon = data.map((d) => d.consumption).reduce(max) * 1.1;
    final maxGen = data.map((d) => d.generation).reduce(max) * 1.1;
    final maxV = max(maxCon, maxGen);

    // Horizontal grid lines
    for (int i = 0; i <= 3; i++) {
      final y = padT + h - (i / 3) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(padL + w, y),
        Paint()
          ..color = C.muted.withOpacity(0.15)
          ..strokeWidth = 0.5,
      );
    }

    void drawArea(List<double> vals, Color col) {
      final path = Path();
      final fillPath = Path();
      bool started = false;
      for (int i = 0; i < vals.length; i++) {
        final x = padL + (i / (vals.length - 1)) * w;
        final y = padT + h - (vals[i] / maxV).clamp(0, 1) * h;
        if (!started) {
          path.moveTo(x, y);
          fillPath.moveTo(x, padT + h);
          fillPath.lineTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }
      fillPath.lineTo(padL + w, padT + h);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [col.withOpacity(0.18 + glowT * 0.06), col.withOpacity(0)],
          ).createShader(Rect.fromLTWH(padL, padT, w, h)),
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = col
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1 + glowT * 0.5),
      );
    }

    drawArea(data.map((d) => d.generation).toList(), C.green);
    drawArea(data.map((d) => d.consumption).toList(), C.amber);

    // Hour labels
    for (int i = 0; i < 24; i += 4) {
      final x = padL + (i / 23) * w;
      final tp = TextPainter(
        text: TextSpan(
          text: '${i.toString().padLeft(2, '0')}:00',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 3));
    }

    // Legend
    final items = [('CONSUMPTION', C.amber), ('GENERATION', C.green)];
    double lx = padL;
    for (final item in items) {
      canvas.drawLine(
        Offset(lx, padT + 5),
        Offset(lx + 14, padT + 5),
        Paint()
          ..color = item.$2
          ..strokeWidth = 2,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: item.$1,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: item.$2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx + 18, padT));
      lx += tp.width + 36;
    }
  }

  @override
  bool shouldRepaint(HourlyChartPainter o) => o.glowT != glowT;
}
