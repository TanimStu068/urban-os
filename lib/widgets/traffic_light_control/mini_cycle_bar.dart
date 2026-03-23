import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';

typedef C = AppColors;

class MiniCycleBar extends StatelessWidget {
  final Intersection ix;
  final double glowT;
  const MiniCycleBar({super.key, required this.ix, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    int elapsed = 0;
    if (ix.phase == SignalPhase.green)
      elapsed = ix.greenDuration - ix.timer;
    else if (ix.phase == SignalPhase.yellow)
      elapsed = ix.greenDuration + (ix.yellowDuration - ix.timer);
    else
      elapsed =
          ix.greenDuration + ix.yellowDuration + (ix.redDuration - ix.timer);
    final progress = (elapsed / ix.cycleDuration).clamp(0.0, 1.0);
    final green = ix.greenDuration / ix.cycleDuration;
    final yellow = ix.yellowDuration / ix.cycleDuration;

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: ix.greenDuration,
                child: Container(height: 6, color: C.green.withOpacity(0.15)),
              ),
              Flexible(
                flex: ix.yellowDuration,
                child: Container(height: 6, color: C.amber.withOpacity(0.15)),
              ),
              Flexible(
                flex: ix.redDuration,
                child: Container(height: 6, color: C.red.withOpacity(0.15)),
              ),
            ],
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    C.green.withOpacity(0.8),
                    C.amber.withOpacity(0.8),
                    C.red.withOpacity(0.8),
                  ],
                  stops: [green, green + yellow, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
