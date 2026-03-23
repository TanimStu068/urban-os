import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SlotGridPainter extends CustomPainter {
  final int total, occupied, reserved, disabled;
  final double progress, glowT, pulseT;
  final Color color;
  SlotGridPainter({
    required this.total,
    required this.occupied,
    required this.reserved,
    required this.disabled,
    required this.progress,
    required this.glowT,
    required this.pulseT,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF030D18));

    final cols = 20;
    final rows = (total / cols).ceil();
    final cellW = (s.width - 16) / cols;
    final cellH = (s.height - 16) / rows;
    final cx = cellW * 0.85, cy = cellH * 0.75;
    final padX = (s.width - cols * cellW) / 2;
    final padY = (s.height - rows * cellH) / 2;

    // Animated reveal: draw (total * progress) slots
    final drawCount = (total * progress).ceil().clamp(0, total);

    for (int i = 0; i < drawCount; i++) {
      final col = i % cols, row = i ~/ cols;
      final x = padX + col * cellW + (cellW - cx) / 2;
      final y = padY + row * cellH + (cellH - cy) / 2;

      Color slotCol;
      bool isGlowing = false;
      if (i < disabled) {
        slotCol = C.mutedLt.withOpacity(0.3);
      } else if (i < disabled + reserved) {
        slotCol = C.violet.withOpacity(0.6);
        isGlowing = true;
      } else if (i < disabled + reserved + occupied) {
        slotCol = color.withOpacity(0.7);
        isGlowing =
            i ==
            disabled + reserved + occupied - 1; // last occupied slot pulses
      } else {
        slotCol = C.green.withOpacity(0.35);
      }

      // Car silhouette (occupied) vs empty line (free)
      final rr = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cx, cy),
        const Radius.circular(2),
      );
      if (i < disabled + reserved + occupied) {
        canvas.drawRRect(rr, Paint()..color = slotCol);
        if (isGlowing) {
          canvas.drawRRect(
            rr,
            Paint()
              ..color = slotCol.withOpacity(0.3 + pulseT * 0.2)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
          );
        }
      } else {
        canvas.drawRRect(
          rr,
          Paint()
            ..color = slotCol
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.7,
        );
      }
    }

    // Label
    final available = total - occupied - reserved;
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$available',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: C.green.withOpacity(0.6 + glowT * 0.3),
            ),
          ),
          const TextSpan(
            text: ' FREE SPACES',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              letterSpacing: 1.5,
              color: C.green,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          s.width / 2 - tp.width / 2 - 8,
          s.height - 18,
          tp.width + 16,
          16,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = C.bg.withOpacity(0.8),
    );
    tp.paint(canvas, Offset(s.width / 2 - tp.width / 2, s.height - 16));
  }

  @override
  bool shouldRepaint(SlotGridPainter o) =>
      o.progress != progress ||
      o.glowT != glowT ||
      o.occupied != occupied ||
      o.pulseT != pulseT;
}
