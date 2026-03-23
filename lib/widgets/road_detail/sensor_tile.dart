import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';

class SensorTile extends StatelessWidget {
  final Sensor sensor;
  final double glowT, blinkT, pulseT;
  const SensorTile({
    super.key,
    required this.sensor,
    required this.glowT,
    required this.blinkT,
    required this.pulseT,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = sensor.isOnline ? sensor.color : C.muted;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard2.withOpacity(0.7),
        border: Border.all(
          color: col.withOpacity(sensor.isOnline ? 0.2 + glowT * 0.07 : 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(sensor.isOnline ? 0.1 : 0.05),
              border: Border.all(
                color: col.withOpacity(sensor.isOnline ? 0.3 : 0.1),
              ),
            ),
            child: Icon(
              sensor.icon,
              color: col.withOpacity(sensor.isOnline ? 1 : 0.35),
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sensor.type,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          letterSpacing: 0.5,
                          color: col.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: sensor.isOnline
                            ? C.green.withOpacity(0.5 + blinkT * 0.5)
                            : C.red.withOpacity(0.5),
                        boxShadow: sensor.isOnline
                            ? [
                                BoxShadow(
                                  color: C.green.withOpacity(0.4 * blinkT),
                                  blurRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ],
                ),
                Text(
                  sensor.isOnline
                      ? '${sensor.value} ${sensor.unit}'
                      : 'OFFLINE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: sensor.isOnline ? col : C.muted.withOpacity(0.5),
                  ),
                ),
                if (sensor.isOnline) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        height: 2,
                        width: 40 * sensor.signalStrength,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: col.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${(sensor.signalStrength * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          color: col.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
