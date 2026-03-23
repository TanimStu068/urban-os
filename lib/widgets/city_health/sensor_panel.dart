import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';
import 'package:urban_os/widgets/city_health/empty_state.dart';
import 'package:urban_os/widgets/city_health/card.dart';

typedef C = AppColors;

class SensorsPanel extends StatelessWidget {
  final List<SensorModel> sensors;
  final AnimationController glowCtrl;
  const SensorsPanel({
    super.key,
    required this.sensors,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (sensors.isEmpty) {
      return CardWidget(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: EmptyState(
          icon: Icons.sensors_off_rounded,
          message: 'No sensors registered',
        ),
      );
    }
    // group by type, show max 8 groups
    final byType = <String, List<SensorModel>>{};
    for (final s in sensors) {
      byType.putIfAbsent(s.type.name, () => []).add(s);
    }
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'SENSOR NETWORK (${sensors.length})',
            icon: Icons.sensors_rounded,
            color: C.cyan,
          ),
          ...byType.entries.take(8).map((e) {
            final list = e.value;
            final avg =
                list.map((s) => s.val).fold(0.0, (a, b) => a + b) / list.length;
            final min = list.map((s) => s.val).reduce((a, b) => a < b ? a : b);
            final max = list.map((s) => s.val).reduce((a, b) => a > b ? a : b);
            final col = list.first.statusColor;
            return AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: col.withOpacity(.04),
                  border: Border.all(
                    color: col.withOpacity(.12 + glowCtrl.value * .06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: col.withOpacity(.1),
                        border: Border.all(color: col.withOpacity(.25)),
                      ),
                      child: Icon(Icons.sensors_rounded, color: col, size: 13),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: col,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                'avg ${avg.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 8,
                                  color: C.muted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'min ${min.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 8,
                                  color: C.muted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'max ${max.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 8,
                                  color: C.muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '×${list.length}',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: col,
                          ),
                        ),
                        Text(
                          'units',
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
            );
          }),
        ],
      ),
    );
  }
}
