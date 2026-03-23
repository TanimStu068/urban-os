import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/tag_chip.dart';

typedef C = AppColors;

class LaneRow extends StatelessWidget {
  final LaneInfo lane;
  final double glowT;
  const LaneRow({super.key, required this.lane, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    final col = lane.congestion >= 0.85
        ? C.red
        : lane.congestion >= 0.6
        ? C.amber
        : C.green;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: C.bgCard2.withOpacity(0.5),
        border: Border.all(color: col.withOpacity(0.2 + glowT * 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(0.1),
              border: Border.all(color: col.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                'L${lane.laneNum}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: col,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TagChip(lane.direction, kAccent),
                    const SizedBox(width: 5),
                    TagChip(lane.type, C.violet),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    children: [
                      Container(height: 4, color: col.withOpacity(0.1)),
                      FractionallySizedBox(
                        widthFactor: lane.congestion,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [col.withOpacity(0.5), col],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: col.withOpacity(0.3),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${lane.speed} km/h',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: col,
                ),
              ),
              Text(
                '${lane.vehicles}/h',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.muted,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Text(
            '${(lane.congestion * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: col,
            ),
          ),
        ],
      ),
    );
  }
}
