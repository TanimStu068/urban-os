import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/cycle_ratio.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class CycleSummaryBar extends StatelessWidget {
  final Intersection ix;
  final double glowT;
  const CycleSummaryBar({super.key, required this.ix, required this.glowT});

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: kAccent.withOpacity(0.04),
      border: Border.all(color: kAccent.withOpacity(0.12)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TOTAL CYCLE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.muted,
                ),
              ),
              Text(
                '${ix.cycleDuration}s',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: kAccent,
                  shadows: [
                    Shadow(color: kAccent.withOpacity(0.4), blurRadius: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CycleRatio('G', ix.greenDuration, ix.cycleDuration, C.green),
            CycleRatio('Y', ix.yellowDuration, ix.cycleDuration, C.amber),
            CycleRatio('R', ix.redDuration, ix.cycleDuration, C.red),
          ],
        ),
      ],
    ),
  );
}
