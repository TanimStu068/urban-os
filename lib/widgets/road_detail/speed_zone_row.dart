import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';

class SpeedZoneRow extends StatelessWidget {
  final SpeedZone zone;
  final double glowT;
  const SpeedZoneRow({required this.zone, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    final pct = zone.currentSpeed / zone.limit;
    final col = pct < 0.5
        ? C.red
        : pct < 0.75
        ? C.amber
        : C.green;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: C.bgCard2.withOpacity(0.5),
        border: Border.all(color: col.withOpacity(0.18 + glowT * 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(0.1),
              border: Border.all(color: col.withOpacity(0.4), width: 2),
            ),
            child: Center(
              child: Text(
                '${zone.limit}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: col,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: C.white,
                  ),
                ),
                Text(
                  'KM ${zone.startKm.toStringAsFixed(1)} → ${zone.endKm.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.muted,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    children: [
                      Container(height: 4, color: col.withOpacity(0.1)),
                      FractionallySizedBox(
                        widthFactor: pct.clamp(0, 1),
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${zone.currentSpeed}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: col,
                  shadows: [Shadow(color: col.withOpacity(0.4), blurRadius: 6)],
                ),
              ),
              Text(
                'km/h',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
