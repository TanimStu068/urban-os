import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

class ClimateChartPainter extends CustomPainter {
  final List<HourlyEnvPoint> data;
  final double glow;
  const ClimateChartPainter({required this.data, required this.glow});

  @override
  void paint(Canvas canvas, Size s) {
    if (data.isEmpty) return;
    const padL = 8.0, padR = 8.0, padT = 10.0, padB = 16.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;
    final n = data.length;

    void draw(List<double> vals, Color col, double maxV, {bool fill = false}) {
      final path = Path(), fp = Path();
      for (int i = 0; i < n; i++) {
        final x = padL + (i / (n - 1)) * w;
        final y = padT + h - (vals[i] / maxV).clamp(0, 1) * h;
        if (i == 0) {
          path.moveTo(x, y);
          fp.moveTo(x, padT + h);
          fp.lineTo(x, y);
        } else {
          path.lineTo(x, y);
          fp.lineTo(x, y);
        }
      }
      if (fill) {
        fp.lineTo(padL + w, padT + h);
        fp.close();
        canvas.drawPath(
          fp,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [col.withOpacity(0.15 + glow * 0.05), col.withOpacity(0)],
            ).createShader(Rect.fromLTWH(padL, padT, w, h)),
        );
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = col
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    draw(data.map((d) => d.temp).toList(), C.amber, 45, fill: true);
    draw(data.map((d) => d.humidity).toList(), C.cyan, 100, fill: false);
    draw(data.map((d) => d.rainfall * 10).toList(), C.sky, 60, fill: false);

    for (int i = 0; i < n; i += 4) {
      final x = padL + (i / (n - 1)) * w;
      final tp = TextPainter(
        text: TextSpan(
          text: '${i.toString().padLeft(2, '0')}h',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 2));
    }
  }

  @override
  bool shouldRepaint(ClimateChartPainter o) => o.glow != glow;
}
