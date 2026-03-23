import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';

typedef C = AppColors;

class CompactApproachCard extends StatelessWidget {
  final ApproachLane lane;
  final double glowT;
  const CompactApproachCard({
    super.key,
    required this.lane,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) {
    final pct = (lane.queueLength / 200).clamp(0.0, 1.0);
    final col = pct > 0.75
        ? C.red
        : pct > 0.5
        ? C.amber
        : C.green;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: C.bgCard2.withOpacity(0.6),
        border: Border.all(color: col.withOpacity(0.15 + glowT * 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(0.12),
              border: Border.all(color: col.withOpacity(0.35)),
            ),
            child: Center(
              child: Text(
                lane.direction,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: col,
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${lane.waitingVehicles}v',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          color: C.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${lane.queueLength}m',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: col,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    children: [
                      Container(height: 3, color: col.withOpacity(0.1)),
                      FractionallySizedBox(
                        widthFactor: pct,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [col.withOpacity(0.5), col],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
