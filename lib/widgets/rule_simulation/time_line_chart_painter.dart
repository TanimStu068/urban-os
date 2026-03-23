import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/models/automation/automation_rule.dart';

class TimelineChartPainter extends CustomPainter {
  final List<SimTick> ticks;
  final List<SimSensor> sensors;
  final AutomationRule? rule;
  final double glowT;

  TimelineChartPainter({
    required this.ticks,
    required this.sensors,
    required this.rule,
    required this.glowT,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (ticks.isEmpty || rule == null) return;
    const padL = 8.0, padR = 18.0, padT = 8.0, padB = 20.0;
    final w = s.width - padL - padR;
    final h = s.height - padT - padB;

    // Trigger zones
    for (int i = 0; i < ticks.length; i++) {
      if (ticks[i].ruleTriggered) {
        final x = padL + (ticks.length > 1 ? i / (ticks.length - 1) : 0.5) * w;
        canvas.drawRect(
          Rect.fromLTWH(x - 1, padT, 3, h),
          Paint()..color = C.violet.withOpacity(0.08),
        );
      }
    }

    // Sensor lines
    final colors = [C.amber, C.cyan, C.green, C.pink, C.sky];
    for (int si = 0; si < sensors.length; si++) {
      final sensor = sensors[si];
      final linePaint = Paint()
        ..color = colors[si % colors.length].withOpacity(0.75)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final path = Path();
      bool started = false;
      for (int i = 0; i < ticks.length; i++) {
        final val = ticks[i].sensorValues[sensor.sensorId] ?? sensor.value;
        final range = sensor.maxRange - sensor.minRange;
        if (range == 0) continue;
        final x = padL + (ticks.length > 1 ? i / (ticks.length - 1) : 0.5) * w;
        final y =
            padT + h - ((val - sensor.minRange) / range).clamp(0.0, 1.0) * h;
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);

      // Threshold line
      final range = sensor.maxRange - sensor.minRange;
      if (range > 0 && si < rule!.conditions.length) {
        final cond = rule!.conditions[si];
        final threshY =
            padT +
            h -
            ((cond.threshold - sensor.minRange) / range).clamp(0.0, 1.0) * h;
        canvas.drawLine(
          Offset(padL, threshY),
          Offset(padL + w, threshY),
          Paint()
            ..color = C.amber.withOpacity(0.25)
            ..strokeWidth = 1,
        );
        final tp = TextPainter(
          text: TextSpan(
            text: 'T${si + 1}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.amber.withOpacity(0.5),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(padL + w + 2, threshY - 5));
      }
    }

    // Trigger dots
    for (int i = 0; i < ticks.length; i++) {
      if (ticks[i].ruleTriggered) {
        final x = padL + (ticks.length > 1 ? i / (ticks.length - 1) : 0.5) * w;
        canvas.drawCircle(
          Offset(x, padT + h),
          3.5,
          Paint()
            ..color = C.violet.withOpacity(0.8 + glowT * 0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // X-axis labels
    for (
      int i = 0;
      i < ticks.length;
      i += (ticks.length / 5).ceil().clamp(1, 99)
    ) {
      final x = padL + (ticks.length > 1 ? i / (ticks.length - 1) : 0.5) * w;
      final tp = TextPainter(
        text: TextSpan(
          text: '${ticks[i].tick}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, s.height - padB + 4));
    }
  }

  @override
  bool shouldRepaint(TimelineChartPainter o) =>
      o.ticks.length != ticks.length || o.glowT != glowT;
}
