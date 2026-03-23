import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';

class FloorRow extends StatelessWidget {
  final ParkingFloor floor;
  final double glowT;
  const FloorRow({required this.floor, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    final col = floor.rate >= 0.9
        ? C.red
        : floor.rate >= 0.65
        ? C.amber
        : C.green;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: C.bgCard2.withOpacity(0.5),
        border: Border.all(color: col.withOpacity(0.15 + glowT * 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: col.withOpacity(0.1),
              border: Border.all(color: col.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                floor.label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
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
                    Flexible(
                      child: Text(
                        '${floor.occupied}/${floor.total}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: col,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    children: [
                      Container(height: 4, color: col.withOpacity(0.1)),
                      FractionallySizedBox(
                        widthFactor: floor.rate.clamp(0, 1),
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
          Text(
            '${(floor.rate * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: col,
              shadows: [Shadow(color: col.withOpacity(0.4), blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}
