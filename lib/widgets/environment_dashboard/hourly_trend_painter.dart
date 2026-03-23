import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

class HourlyTrendPainter extends CustomPainter {
  final List<HourlyEnvPoint> data;
  final double glow;
  const HourlyTrendPainter({required this.data, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    const padL = 8.0, padR = 8.0, padT = 8.0, padB = 18.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;
    final n = data.length;

    void drawLine(List<double> vals, Color col, double maxV) {
      final path = Path(), fill = Path();
      bool started = false;
      for (int i = 0; i < n; i++) {
        final x = padL + (i / (n - 1)) * w;
        final y = padT + h - (vals[i] / maxV).clamp(0, 1) * h;
        if (!started) {
          path.moveTo(x, y);
          fill.moveTo(x, padT + h);
          fill.lineTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
          fill.lineTo(x, y);
        }
      }
      fill.lineTo(padL + w, padT + h);
      fill.close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [col.withOpacity(0.12 + glow * 0.04), col.withOpacity(0)],
          ).createShader(Rect.fromLTWH(padL, padT, w, h)),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = col.withOpacity(0.2 + glow * 0.08)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = col
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    drawLine(data.map((d) => d.temp).toList(), C.amber, 45);
    drawLine(data.map((d) => d.humidity).toList(), C.cyan, 100);
    drawLine(data.map((d) => d.aqi / 2).toList(), C.teal, 100);
    drawLine(data.map((d) => d.rainfall * 8).toList(), C.sky, 50);

    // Hour labels
    for (int i = 0; i < n; i += 4) {
      final x = padL + (i / (n - 1)) * w;
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
  }

  @override
  bool shouldRepaint(HourlyTrendPainter o) => o.glow != glow;
}
