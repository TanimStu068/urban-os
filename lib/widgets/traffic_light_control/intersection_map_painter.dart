import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'dart:math';

typedef C = AppColors;
const kAccent = C.cyan;

class IntersectionMapPainter extends CustomPainter {
  final Intersection ix;
  final double glowT, pulseT, blinkT;
  IntersectionMapPainter({
    required this.ix,
    required this.glowT,
    required this.pulseT,
    required this.blinkT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));

    final gp = Paint()
      ..color = kAccent.withOpacity(0.025)
      ..strokeWidth = 0.3;
    for (double x = 0; x < s.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), gp);
    }
    for (double y = 0; y < s.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), gp);
    }
    final cx = s.width / 2, cy = s.height / 2;
    const roadW = 24.0;
    final col = ix.phase.color;

    canvas.drawRect(
      Rect.fromLTWH(0, cy - roadW / 2, s.width, roadW),
      Paint()..color = const Color(0xFF0A1E30),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - roadW / 2, 0, roadW, s.height),
      Paint()..color = const Color(0xFF0A1E30),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - roadW / 2, cy - roadW / 2, roadW, roadW),
      Paint()..color = const Color(0xFF0D2240),
    );

    _drawDashedH(
      canvas,
      Offset(0, cy),
      Offset(cx - roadW / 2, cy),
      C.white.withOpacity(0.08),
    );
    _drawDashedH(
      canvas,
      Offset(cx + roadW / 2, cy),
      Offset(s.width, cy),
      C.white.withOpacity(0.08),
    );
    _drawDashedV(
      canvas,
      Offset(cx, 0),
      Offset(cx, cy - roadW / 2),
      C.white.withOpacity(0.08),
    );
    _drawDashedV(
      canvas,
      Offset(cx, cy + roadW / 2),
      Offset(cx, s.height),
      C.white.withOpacity(0.08),
    );

    _paintText(
      canvas,
      ix.road1,
      Offset(6, cy - roadW / 2 - 12),
      6,
      kAccent.withOpacity(0.45),
    );
    _paintText(
      canvas,
      ix.road2,
      Offset(cx + roadW / 2 + 4, 6),
      6,
      kAccent.withOpacity(0.45),
    );

    for (final a in ix.approaches) {
      final qPct = (a.queueLength / 200).clamp(0.0, 1.0);
      final qCol = qPct > 0.75
          ? C.red
          : qPct > 0.5
          ? C.amber
          : C.green;
      late Offset qStart, qEnd, labelPos;
      switch (a.direction) {
        case 'N':
          qStart = Offset(cx - 3, cy - roadW / 2);
          qEnd = Offset(cx - 3, cy - roadW / 2 - qPct * 55);
          labelPos = Offset(cx + 2, cy - roadW / 2 - 9);
          break;
        case 'S':
          qStart = Offset(cx + 3, cy + roadW / 2);
          qEnd = Offset(cx + 3, cy + roadW / 2 + qPct * 55);
          labelPos = Offset(cx + 5, cy + roadW / 2 + 10);
          break;
        case 'E':
          qStart = Offset(cx + roadW / 2, cy - 3);
          qEnd = Offset(cx + roadW / 2 + qPct * 55, cy - 3);
          labelPos = Offset(cx + roadW / 2 + 6, cy - 12);
          break;
        case 'W':
          qStart = Offset(cx - roadW / 2, cy + 3);
          qEnd = Offset(cx - roadW / 2 - qPct * 55, cy + 3);
          labelPos = Offset(cx - roadW / 2 - 32, cy + 7);
          break;
      }
      canvas.drawLine(
        qStart,
        qEnd,
        Paint()
          ..color = qCol.withOpacity(0.4)
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      _paintText(
        canvas,
        '${a.waitingVehicles}v',
        labelPos,
        6.5,
        qCol.withOpacity(0.8),
      );
    }

    final pulseR = 12.0 + pulseT * 2;
    canvas.drawCircle(
      Offset(cx, cy),
      pulseR,
      Paint()
        ..color = col.withOpacity(0.07 * (1 - pulseT))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 7, cy - 18, 14, 36),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF060F1A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 7, cy - 18, 14, 36),
        const Radius.circular(4),
      ),
      Paint()
        ..color = col.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    final lights = [
      (C.red, SignalPhase.red),
      (C.amber, SignalPhase.yellow),
      (C.green, SignalPhase.green),
    ];
    for (int i = 0; i < 3; i++) {
      final (lCol, lPhase) = lights[i];
      final isOn = ix.phase == lPhase;
      final ly = cy - 11 + i * 11.0;
      canvas.drawCircle(
        Offset(cx, ly),
        3.5,
        Paint()..color = lCol.withOpacity(isOn ? 0.9 + glowT * 0.1 : 0.1),
      );
      if (isOn) {
        canvas.drawCircle(
          Offset(cx, ly),
          6,
          Paint()
            ..color = lCol.withOpacity(0.3 + glowT * 0.15)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }
    }

    final phTp = TextPainter(
      text: TextSpan(
        text: ix.phase.label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          fontWeight: FontWeight.w700,
          color: col,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    phTp.paint(canvas, Offset(cx - phTp.width / 2, cy + 20));

    final timerTp = TextPainter(
      text: TextSpan(
        text: '${ix.timer}s',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: col,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    timerTp.paint(canvas, Offset(cx - timerTp.width / 2, cy + 29));

    _drawArrow(
      canvas,
      Offset(cx, cy - 45),
      Offset(cx, cy - roadW / 2 - 3),
      col.withOpacity(0.2),
    );
    _drawArrow(
      canvas,
      Offset(cx, cy + 45),
      Offset(cx, cy + roadW / 2 + 3),
      col.withOpacity(0.2),
    );
    _drawArrow(
      canvas,
      Offset(cx + 45, cy),
      Offset(cx + roadW / 2 + 3, cy),
      col.withOpacity(0.2),
    );
  }

  void _drawDashedH(Canvas canvas, Offset a, Offset b, Color col) {
    double x = a.dx;
    while (x < b.dx - 5) {
      canvas.drawLine(
        Offset(x, a.dy),
        Offset(min(x + 6, b.dx), a.dy),
        Paint()
          ..color = col
          ..strokeWidth = 0.7
          ..strokeCap = StrokeCap.round,
      );
      x += 12;
    }
  }

  void _drawDashedV(Canvas canvas, Offset a, Offset b, Color col) {
    double y = a.dy;
    while (y < b.dy - 5) {
      canvas.drawLine(
        Offset(a.dx, y),
        Offset(a.dx, min(y + 6, b.dy)),
        Paint()
          ..color = col
          ..strokeWidth = 0.7
          ..strokeCap = StrokeCap.round,
      );
      y += 12;
    }
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color col) {
    canvas.drawLine(
      from,
      to,
      Paint()
        ..color = col
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );
    final dir = (to - from) / (to - from).distance;
    final perp = Offset(-dir.dy, dir.dx);
    canvas.drawLine(
      to,
      to - dir * 5 + perp * 3,
      Paint()
        ..color = col
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      to,
      to - dir * 5 - perp * 3,
      Paint()
        ..color = col
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset pos,
    double sz,
    Color col,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontFamily: 'monospace', fontSize: sz, color: col),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(IntersectionMapPainter o) =>
      o.glowT != glowT || o.pulseT != pulseT || o.blinkT != blinkT;
}
