import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'dart:math';

class GridFlowPainter extends CustomPainter {
  final List<PowerZone> zones;
  final List<EnergySourceModel> sources;
  final bool showFlow;
  final double flowT, glowT, blinkT;

  GridFlowPainter({
    required this.zones,
    required this.sources,
    required this.showFlow,
    required this.flowT,
    required this.glowT,
    required this.blinkT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    const cX = 0.5, cY = 0.45;
    final cx = s.width * cX, cy = s.height * cY;
    const nodeR = 22.0;

    // Source positions (left arc)
    final srcPositions = <Offset>[];
    for (int i = 0; i < sources.length; i++) {
      final angle = -pi * 0.65 + (i / (sources.length - 1)) * pi * 1.3;
      srcPositions.add(
        Offset(
          cx - s.width * 0.32 + cos(angle) * 10,
          cy + sin(angle) * s.height * 0.38,
        ),
      );
    }

    // Zone positions (right arc)
    final zonePositions = <Offset>[];
    final displayZones = zones.take(8).toList();
    for (int i = 0; i < displayZones.length; i++) {
      final angle = -pi * 0.72 + (i / (displayZones.length - 1)) * pi * 1.44;
      zonePositions.add(
        Offset(
          cx + s.width * 0.28 + cos(angle) * 8,
          cy + sin(angle) * s.height * 0.42,
        ),
      );
    }

    // Draw flow lines
    if (showFlow) {
      for (int si = 0; si < sources.length; si++) {
        if (!sources[si].isActive) continue;
        final srcPt = srcPositions[si];
        // src -> center
        _drawFlowLine(
          canvas,
          srcPt,
          Offset(cx, cy),
          sources[si].type.color,
          flowT,
          glowT,
        );
      }
      for (int zi = 0; zi < displayZones.length; zi++) {
        final col = displayZones[zi].status.color;
        _drawFlowLine(
          canvas,
          Offset(cx, cy),
          zonePositions[zi],
          col,
          flowT,
          glowT,
        );
      }
    } else {
      // Static lines
      for (int si = 0; si < sources.length; si++) {
        if (!sources[si].isActive) continue;
        canvas.drawLine(
          srcPositions[si],
          Offset(cx, cy),
          Paint()
            ..color = sources[si].type.color.withOpacity(0.15)
            ..strokeWidth = 1,
        );
      }
      for (int zi = 0; zi < displayZones.length; zi++) {
        canvas.drawLine(
          Offset(cx, cy),
          zonePositions[zi],
          Paint()
            ..color = displayZones[zi].status.color.withOpacity(0.15)
            ..strokeWidth = 1,
        );
      }
    }

    // Central node
    _drawNode(
      canvas,
      Offset(cx, cy),
      nodeR * 1.4,
      C.amber,
      glowT,
      icon: Icons.electric_bolt_rounded,
      label: 'GRID\nHUB',
    );

    // Source nodes
    for (int i = 0; i < sources.length; i++) {
      final src = sources[i];
      _drawNode(
        canvas,
        srcPositions[i],
        nodeR,
        src.type.color,
        src.isActive ? glowT : 0,
        icon: src.type.icon,
        label: src.type.label,
        offline: !src.isActive,
      );
    }

    // Zone nodes
    for (int i = 0; i < displayZones.length; i++) {
      final z = displayZones[i];
      final isCrit = z.status == ZoneStatus.critical;
      _drawNode(
        canvas,
        zonePositions[i],
        nodeR * 0.85,
        z.status.color,
        isCrit ? blinkT * glowT : glowT * 0.5,
        icon: Icons.business_rounded,
        label: z.id,
        offline: z.status == ZoneStatus.offline,
      );
    }
  }

  void _drawFlowLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Color col,
    double t,
    double glow,
  ) {
    // Animated dash along the line
    final dir = (to - from);
    final len = dir.distance;
    final norm = dir / len;

    // Base line
    canvas.drawLine(
      from,
      to,
      Paint()
        ..color = col.withOpacity(0.15)
        ..strokeWidth = 1.2,
    );

    // Moving particle
    final particleCount = 3;
    for (int p = 0; p < particleCount; p++) {
      final offset = ((t + p / particleCount) % 1.0);
      final pt = from + norm * (len * offset);
      canvas.drawCircle(
        pt,
        2.5,
        Paint()
          ..color = col.withOpacity(0.5 + glow * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  void _drawNode(
    Canvas canvas,
    Offset pos,
    double r,
    Color col,
    double glow, {
    required IconData icon,
    required String label,
    bool offline = false,
  }) {
    // Glow ring
    canvas.drawCircle(
      pos,
      r + 4,
      Paint()
        ..color = col.withOpacity(0.08 + glow * 0.06)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Fill
    canvas.drawCircle(pos, r, Paint()..color = C.bgCard.withOpacity(0.95));
    // Border
    canvas.drawCircle(
      pos,
      r,
      Paint()
        ..color = col.withOpacity(offline ? 0.2 : 0.4 + glow * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Label below
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 6.5,
          color: col.withOpacity(offline ? 0.4 : 0.8),
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 60);
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy + r + 3));
  }

  @override
  bool shouldRepaint(GridFlowPainter o) =>
      o.flowT != flowT || o.glowT != glowT || o.blinkT != blinkT;
}
