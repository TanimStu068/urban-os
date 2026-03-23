import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/rule_simulation/result_kpi.dart';

typedef C = AppColors;

class SimulationResultSummary extends StatelessWidget {
  final AnimationController glowCtrl;
  final int totalTicks;
  final int triggerCount;
  final DateTime? simStart;
  final DateTime? simEnd;

  const SimulationResultSummary({
    super.key,
    required this.glowCtrl,
    required this.totalTicks,
    required this.triggerCount,
    required this.simStart,
    required this.simEnd,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.teal.withOpacity(0.04),
          border: Border.all(
            color: C.teal.withOpacity(0.3 + glowCtrl.value * 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.assessment_rounded, color: C.teal, size: 16),
                SizedBox(width: 8),
                Text(
                  'SIMULATION RESULT',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: C.teal,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                ResultKpi('TICKS', '$totalTicks', C.cyan),
                ResultKpi('TRIGGERS', '$triggerCount', C.violet),
                ResultKpi(
                  'RATE',
                  totalTicks > 0
                      ? '${(triggerCount / totalTicks * 100).toStringAsFixed(1)}%'
                      : '0%',
                  triggerCount > 0 ? C.amber : C.mutedLt,
                ),
                ResultKpi(
                  'TIME',
                  simEnd != null && simStart != null
                      ? '${simEnd!.difference(simStart!).inSeconds}s'
                      : '—',
                  C.sky,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: triggerCount > 0
                    ? C.violet.withOpacity(0.07)
                    : C.red.withOpacity(0.07),
                border: Border.all(
                  color: triggerCount > 0
                      ? C.violet.withOpacity(0.25)
                      : C.red.withOpacity(0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    triggerCount > 0
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    color: triggerCount > 0 ? C.violet : C.red,
                    size: 14,
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      triggerCount > 0
                          ? 'Rule fired $triggerCount time${triggerCount != 1 ? 's' : ''} during simulation. Logic is working correctly.'
                          : 'Rule never triggered. Check sensor thresholds or try FORCE TRIGGER to validate actions.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: triggerCount > 0 ? C.violet : C.red,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
