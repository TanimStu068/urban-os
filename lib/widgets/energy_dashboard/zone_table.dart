import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/status_badge.dart';
import 'package:urban_os/widgets/energy_dashboard/tab_header_text.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';

typedef C = AppColors;

class ZoneTable extends StatelessWidget {
  final List<PowerZone> zones;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  const ZoneTable({
    super.key,
    required this.zones,
    required this.glowAnimation,
    required this.blinkAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'ZONE LOAD TABLE',
      icon: Icons.table_chart_rounded,
      color: C.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: C.bgCard2,
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: TableHeaderText(text: 'ZONE')),
                Expanded(flex: 2, child: TableHeaderText(text: 'CONSUMPTION')),
                Expanded(flex: 2, child: TableHeaderText(text: 'CAPACITY')),
                Expanded(flex: 2, child: TableHeaderText(text: 'LOAD %')),
                Expanded(flex: 2, child: TableHeaderText(text: 'STATUS')),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Table rows
          ...zones.map(
            (z) => AnimatedBuilder(
              animation: Listenable.merge([glowAnimation, blinkAnimation]),
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: z.status == ZoneStatus.critical
                      ? C.red.withOpacity(0.05 + blinkAnimation.value * 0.03)
                      : C.bgCard2.withOpacity(0.4),
                  border: Border.all(
                    color: z.status == ZoneStatus.critical
                        ? C.red.withOpacity(0.2 + blinkAnimation.value * 0.1)
                        : C.gBdr,
                  ),
                ),
                child: Row(
                  children: [
                    // Zone name
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            z.id,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.amber.withOpacity(0.7),
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            z.name,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              color: C.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Consumption
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${(z.consumption / 1000).toStringAsFixed(2)} MW',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          color: C.amber,
                        ),
                      ),
                    ),
                    // Capacity
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${(z.capacity / 1000).toStringAsFixed(1)} MW',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                        ),
                      ),
                    ),
                    // Load %
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: C.muted.withOpacity(0.3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: (z.loadPct / 100).clamp(0, 1),
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: z.status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${z.loadPct.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8,
                                color: z.status.color,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Expanded(
                      flex: 2,
                      child: StatusBadge(z.status, blinkAnimation.value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
