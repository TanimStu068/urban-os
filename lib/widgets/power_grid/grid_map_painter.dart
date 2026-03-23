import 'package:flutter/material.dart';
import 'dart:math';

import 'package:urban_os/datamodel/power_grid_data_model.dart';

class GridMapPainter extends CustomPainter {
  final List<GridNode> nodes;
  final List<GridLine> lines;
  final List<GridNode> allNodes;
  final double scale, flowT, glowT, blinkT;
  final Offset offset;
  final bool showLabels, showFlow, showHeatmap;
  final String? selectedId;

  GridMapPainter({
    required this.nodes,
    required this.lines,
    required this.allNodes,
    required this.scale,
    required this.offset,
    required this.showLabels,
    required this.showFlow,
    required this.showHeatmap,
    required this.flowT,
    required this.glowT,
    required this.blinkT,
    required this.selectedId,
  });

  Map<String, GridNode> get _nodeMap => {for (final n in allNodes) n.id: n};

  Offset _pos(GridNode n, Size s) => Offset(
    n.position.dx * s.width * scale + offset.dx,
    n.position.dy * s.height * scale + offset.dy,
  );

  @override
  void paint(Canvas canvas, Size s) {
    final nMap = _nodeMap;

    // ── Heatmap zones
    if (showHeatmap) {
      for (final n in allNodes) {
        final p = _pos(n, s);
        final heat = n.loadPct / 100;
        canvas.drawCircle(
          p,
          60 * scale,
          Paint()
            ..color = Color.lerp(
              C.green,
              C.red,
              heat,
            )!.withOpacity(0.06 + heat * 0.04)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
        );
      }
    }

    // ── Draw lines
    for (final line in lines) {
      final fromNode = nMap[line.fromId];
      final toNode = nMap[line.toId];
      if (fromNode == null || toNode == null) continue;

      final from = _pos(fromNode, s);
      final to = _pos(toNode, s);
      final col = line.status.color;
      final isActive =
          line.status == LineStatus.live ||
          line.status == LineStatus.overloaded;

      // Shadow glow for active lines
      if (isActive) {
        canvas.drawLine(
          from,
          to,
          Paint()
            ..color = col.withOpacity(0.12 + glowT * 0.06)
            ..strokeWidth = 8 * scale
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Base line
      final isDash =
          line.status == LineStatus.maintenance ||
          line.status == LineStatus.offline;
      if (isDash) {
        _drawDashedLine(canvas, from, to, col.withOpacity(0.35), 1.2 * scale);
      } else {
        canvas.drawLine(
          from,
          to,
          Paint()
            ..color = col.withOpacity(
              line.status == LineStatus.fault ? (0.3 + blinkT * 0.4) : 0.55,
            )
            ..strokeWidth =
                (line.status == LineStatus.overloaded ? 2.5 : 1.8) * scale
            ..strokeCap = StrokeCap.round,
        );
      }

      // Animated flow particles
      if (showFlow && isActive) {
        final dir = to - from;
        final len = dir.distance;
        final norm = dir / len;
        const pCount = 4;
        for (int p = 0; p < pCount; p++) {
          final t = ((flowT + p / pCount) % 1.0);
          final pt = from + norm * (len * t);
          // Clamp to canvas
          if (pt.dx < 0 || pt.dy < 0 || pt.dx > s.width || pt.dy > s.height)
            continue;
          canvas.drawCircle(
            pt,
            2.5 * scale,
            Paint()
              ..color = col.withOpacity(0.5 + glowT * 0.3)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          );
        }
      }

      // Line load label (mid-point)
      if (showLabels && line.loadPct > 0) {
        final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
        final tp = TextPainter(
          text: TextSpan(
            text: '${line.loadPct.toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5 * scale.clamp(0.8, 1.2),
              color: col.withOpacity(0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        // Background pill
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: mid,
              width: tp.width + 8,
              height: tp.height + 4,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = C.bgCard3.withOpacity(0.85),
        );
        tp.paint(canvas, Offset(mid.dx - tp.width / 2, mid.dy - tp.height / 2));
      }
    }

    // ── Draw nodes
    for (final node in allNodes) {
      // Dim nodes not in filter set
      final isVisible = nodes.any((n) => n.id == node.id);
      final alpha = isVisible ? 1.0 : 0.2;
      _drawNode(canvas, node, s, alpha);
    }
  }

  void _drawNode(Canvas canvas, GridNode node, Size s, double alpha) {
    final p = _pos(node, s);
    final r = node.type.radius * scale;
    final col = node.type.color;
    final isSel = node.id == selectedId;
    final isCrit = node.status == ZoneStatus.critical;
    final isOff = node.status == ZoneStatus.offline;

    // Selection ring
    if (isSel) {
      canvas.drawCircle(
        p,
        r + 8 * scale,
        Paint()
          ..color = col.withOpacity(0.15 + glowT * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
      canvas.drawCircle(
        p,
        r + 5 * scale,
        Paint()
          ..color = col.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Pulse ring for critical
    if (isCrit && !isOff) {
      canvas.drawCircle(
        p,
        r + (4 + blinkT * 6) * scale,
        Paint()
          ..color = C.red.withOpacity((0.4 - blinkT * 0.3).clamp(0, 1))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Glow
    if (!isOff) {
      canvas.drawCircle(
        p,
        r + 2,
        Paint()
          ..color = col.withOpacity((0.12 + glowT * 0.08) * alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // Fill
    canvas.drawCircle(
      p,
      r,
      Paint()..color = C.bgCard.withOpacity(0.95 * alpha),
    );

    // Load ring (arc showing utilisation)
    if (!isOff && node.loadPct > 0) {
      // Track
      canvas.drawCircle(
        p,
        r,
        Paint()
          ..color = C.muted.withOpacity(0.2 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 * scale,
      );
      // Value
      canvas.drawArc(
        Rect.fromCircle(center: p, radius: r),
        -pi / 2,
        (node.loadPct / 100) * 2 * pi,
        false,
        Paint()
          ..color = node.status.color.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 * scale
          ..strokeCap = StrokeCap.round,
      );
    }

    // Border
    canvas.drawCircle(
      p,
      r,
      Paint()
        ..color = (isOff ? C.muted : col).withOpacity(
          (isCrit ? 0.5 + blinkT * 0.2 : 0.45) * alpha,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * scale,
    );

    // Icon (drawn as text glyph — Flutter IconData trick via TextPainter)
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(node.type.icon.codePoint),
        style: TextStyle(
          fontSize: r * 0.8,
          fontFamily: node.type.icon.fontFamily,
          color: (isOff ? C.muted : col).withOpacity(alpha),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(p.dx - iconPainter.width / 2, p.dy - iconPainter.height / 2),
    );

    // Label
    if (showLabels) {
      final name = node.name.split('\n').first;
      final tp = TextPainter(
        text: TextSpan(
          text: name,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize:
                (node.type == NodeType.substation ? 7.5 : 6.5) *
                scale.clamp(0.75, 1.2),
            fontWeight: FontWeight.w700,
            color: (isOff ? C.mutedLt : col).withOpacity(alpha * 0.9),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      // Background
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(p.dx, p.dy + r + 10 * scale),
            width: tp.width + 10,
            height: tp.height + 4,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = C.bgCard3.withOpacity(0.88 * alpha),
      );
      tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy + r + 7 * scale));
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Color col,
    double strokeW,
  ) {
    final dir = (to - from);
    final len = dir.distance;
    final norm = dir / len;
    const dashLen = 6.0, gap = 4.0;
    double d = 0;
    while (d < len) {
      final a = from + norm * d;
      final b = from + norm * min(d + dashLen, len);
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = col
          ..strokeWidth = strokeW,
      );
      d += dashLen + gap;
    }
  }

  @override
  bool shouldRepaint(GridMapPainter o) =>
      o.flowT != flowT ||
      o.glowT != glowT ||
      o.blinkT != blinkT ||
      o.scale != scale ||
      o.offset != offset ||
      o.selectedId != selectedId ||
      o.showLabels != showLabels ||
      o.showFlow != showFlow ||
      o.showHeatmap != showHeatmap;
}
