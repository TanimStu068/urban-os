import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

class SensorCard extends StatelessWidget {
  final EnvSensorReading sensor;
  final double glowT, blinkT;
  const SensorCard({
    super.key,
    required this.sensor,
    required this.glowT,
    required this.blinkT,
  });
  @override
  Widget build(BuildContext ctx) {
    final isAlert = sensor.isWarning || sensor.isCritical;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isAlert
            ? sensor.statusColor.withOpacity(
                0.07 + (sensor.isCritical ? blinkT * 0.02 : 0),
              )
            : C.bgCard.withOpacity(0.85),
        border: Border.all(
          color: isAlert
              ? sensor.statusColor.withOpacity(
                  0.28 + (sensor.isCritical ? blinkT * 0.1 : 0),
                )
              : C.gBdr,
        ),
        boxShadow: isAlert
            ? [
                BoxShadow(
                  color: sensor.statusColor.withOpacity(0.07 + glowT * 0.03),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(sensor.icon, color: sensor.color, size: 13),
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sensor.statusColor.withOpacity(
                    sensor.isCritical ? 0.6 + blinkT * 0.4 : 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: sensor.statusColor.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${sensor.value.toStringAsFixed(sensor.id == 'CO2' ? 0 : 1)}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: sensor.statusColor,
              height: 1.0,
              shadows: [
                Shadow(
                  color: sensor.statusColor.withOpacity(0.4 + glowT * 0.1),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          Text(
            sensor.unit,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 5.5,
              height: 1.0,
              color: C.muted,
            ),
          ),
          const SizedBox(height: 1),
          // Micro bar
          Stack(
            children: [
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.75),
                  color: C.muted.withOpacity(0.3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: sensor.normalizedValue,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.75),
                    color: sensor.statusColor,
                    boxShadow: [
                      BoxShadow(
                        color: sensor.statusColor.withOpacity(0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            sensor.name,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 5,
              color: C.mutedLt,
              letterSpacing: 0.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
