import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/models/automation/rule_condition.dart';

typedef C = AppColors;

class SensorInputRow extends StatelessWidget {
  final SimSensor sensor;
  final bool condMet;
  final double glowT, blinkT;
  final ValueChanged<double> onValueChanged;
  final VoidCallback onOverrideToggled;

  const SensorInputRow({
    super.key,
    required this.sensor,
    required this.condMet,
    required this.glowT,
    required this.blinkT,
    required this.onValueChanged,
    required this.onOverrideToggled,
  });

  @override
  Widget build(BuildContext ctx) {
    final statusColor = condMet ? C.green : C.mutedLt;
    final pct =
        (sensor.value - sensor.minRange) / (sensor.maxRange - sensor.minRange);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: condMet ? C.green.withOpacity(0.04) : C.bgCard2.withOpacity(0.4),
        border: Border.all(
          color: condMet ? C.green.withOpacity(0.2 + glowT * 0.08) : C.gBdr,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sensors_rounded, color: statusColor, size: 12),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  sensor.sensorId,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOverrideToggled,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: sensor.manualOverride
                        ? C.violet.withOpacity(0.15)
                        : C.bgCard2,
                    border: Border.all(
                      color: sensor.manualOverride
                          ? C.violet.withOpacity(0.4)
                          : C.muted.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    sensor.manualOverride ? '⚡ MANUAL' : 'AUTO',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: sensor.manualOverride ? C.violet : C.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: statusColor.withOpacity(0.1),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  condMet ? '✓ MET' : '✗ NOT MET',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: statusColor.withOpacity(0.08),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Column(
                  children: [
                    Text(
                      sensor.value.toStringAsFixed(sensor.value < 10 ? 2 : 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      sensor.condition.sensorId.contains('PCT') ? '%' : '',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        color: C.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (_, constraints) {
                        final threshPct =
                            ((sensor.condition.threshold - sensor.minRange) /
                                    (sensor.maxRange - sensor.minRange))
                                .clamp(0.0, 1.0);
                        return Stack(
                          children: [
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: C.muted.withOpacity(0.2),
                              ),
                            ),
                            Positioned(
                              left: threshPct * constraints.maxWidth - 1,
                              top: -2,
                              child: Container(
                                width: 2,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: C.amber,
                                  boxShadow: [
                                    BoxShadow(color: C.amber, blurRadius: 3),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: pct.clamp(0.0, 1.0),
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: statusColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: statusColor.withOpacity(0.6),
                        inactiveTrackColor: C.muted.withOpacity(0.2),
                        thumbColor: statusColor,
                        overlayColor: statusColor.withOpacity(0.1),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 5,
                        ),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: sensor.value.clamp(
                          sensor.minRange,
                          sensor.maxRange,
                        ),
                        min: sensor.minRange,
                        max: sensor.maxRange,
                        onChanged: onValueChanged,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${sensor.minRange.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.muted,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'THRESHOLD: ',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7,
                                color: C.muted,
                              ),
                            ),
                            Text(
                              '${sensor.condition.operatorType.symbol} ${sensor.condition.threshold.toStringAsFixed(sensor.condition.threshold == sensor.condition.threshold.toInt() ? 0 : 1)}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7,
                                color: C.amber,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${sensor.maxRange.toInt()}',
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
