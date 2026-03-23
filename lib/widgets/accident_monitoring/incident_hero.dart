import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/action_button.dart';
import 'package:urban_os/widgets/accident_monitoring/hero_kpi.dart';

typedef C = AppColors;

class IncidentHero extends StatelessWidget {
  final AccidentEvent acc;
  final AnimationController glowCtrl;
  final VoidCallback? onCloseIncident;

  const IncidentHero({
    super.key,
    required this.acc,
    required this.glowCtrl,
    this.onCloseIncident,
  });

  @override
  Widget build(BuildContext context) {
    final col = acc.severity.color;

    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.92),
          border: Border.all(
            color: col.withOpacity(0.25 + glowCtrl.value * 0.1),
          ),
          boxShadow: [BoxShadow(color: col.withOpacity(0.08), blurRadius: 24)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withOpacity(0.1),
                  ),
                  child: Icon(acc.severity.icon, color: col, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acc.id,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: C.white,
                        ),
                      ),
                      Text(
                        acc.road,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                      ),
                      Text(
                        acc.location,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        acc.time,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: C.white,
                        ),
                      ),
                      Text(
                        acc.district,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // KPIs Row
            Row(
              children: [
                Expanded(
                  child: HeroKpi('${acc.vehiclesInvolved}', 'VEHICLES', col),
                ),
                Expanded(
                  child: HeroKpi(
                    '${acc.injuriesReported}',
                    'INJURIES',
                    acc.injuriesReported > 0 ? C.red : C.green,
                  ),
                ),
                Expanded(
                  child: HeroKpi(
                    '${acc.lanesBlocked}/${acc.totalLanes}',
                    'LANES BLOCKED',
                    acc.lanesBlocked > 0 ? C.amber : C.green,
                  ),
                ),
                Expanded(
                  child: HeroKpi(
                    '${acc.dispatchedUnits.length}',
                    'UNITS',
                    C.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons
            ActionButtons(accident: acc, onCloseIncident: onCloseIncident),
          ],
        ),
      ),
    );
  }
}
