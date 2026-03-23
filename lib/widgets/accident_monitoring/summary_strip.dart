import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/automation_rule/sumkpi.dart';
import 'package:urban_os/widgets/accident_monitoring/vdiv.dart';

typedef C = AppColors;

class SummaryStrip extends StatelessWidget {
  final AnimationController glowCtrl;
  final int totalToday;
  final int activeCount;
  final int criticalCount;
  final int totalInjuries;
  final int totalUnits;

  const SummaryStrip({
    Key? key,
    required this.glowCtrl,
    required this.totalToday,
    required this.activeCount,
    required this.criticalCount,
    required this.totalInjuries,
    required this.totalUnits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: C.bgCard.withOpacity(0.88),
          border: Border.all(
            color: C.red.withOpacity(0.15 + glowCtrl.value * 0.06),
          ),
          boxShadow: [
            BoxShadow(color: C.red.withOpacity(0.04), blurRadius: 18),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SumKpi(
                '$totalToday',
                'TOTAL TODAY',
                C.teal, // or kAccent
                Icons.report_rounded,
              ),
            ),
            VDiv(),
            Expanded(
              child: SumKpi(
                '$activeCount',
                'ACTIVE',
                C.red,
                Icons.car_crash_rounded,
              ),
            ),
            VDiv(),
            Expanded(
              child: SumKpi(
                '$criticalCount',
                'CRITICAL',
                C.red,
                Icons.emergency_rounded,
              ),
            ),
            VDiv(),
            Expanded(
              child: SumKpi(
                '$totalInjuries',
                'INJURIES',
                C.orange,
                Icons.personal_injury_rounded,
              ),
            ),
            VDiv(),
            Expanded(
              child: SumKpi(
                '$totalUnits',
                'UNITS OUT',
                C.amber,
                Icons.local_fire_department_rounded,
              ),
            ),
            VDiv(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: C.red.withOpacity(0.1),
                    border: Border.all(color: C.red.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.sensors_rounded,
                    color: C.red.withOpacity(0.7 + glowCtrl.value * 0.3),
                    size: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'LIVE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    letterSpacing: 2,
                    color: C.red.withOpacity(0.6 + glowCtrl.value * 0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
