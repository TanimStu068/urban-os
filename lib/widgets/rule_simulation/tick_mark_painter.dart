import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';

class TickMarkPainter extends CustomPainter {
  final List<SimTick> ticks;
  final int total;
  TickMarkPainter({required this.ticks, required this.total});

  @override
  void paint(Canvas canvas, Size s) {
    if (ticks.isEmpty || total == 0) return;
    for (final t in ticks) {
      final x = (t.tick / total) * s.width;
      final col = t.ruleTriggered ? C.violet : C.muted;
      canvas.drawLine(
        Offset(x, t.ruleTriggered ? 0 : 4),
        Offset(x, s.height),
        Paint()
          ..color = col.withOpacity(t.ruleTriggered ? 0.7 : 0.25)
          ..strokeWidth = t.ruleTriggered ? 2 : 1,
      );
    }
  }

  @override
  bool shouldRepaint(TickMarkPainter o) => o.ticks.length != ticks.length;
}
