import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/enviroment/weather_simulation_screen.dart';
import 'package:urban_os/widgets/automation_rule/sumkpi.dart';
import 'package:urban_os/widgets/automation_rule/vdv.dart';

class RuleSummaryStrip extends StatelessWidget {
  final int total;
  final int active;
  final int triggered;
  final int errors;
  final int totalFires;
  final Animation<double> glowT;
  final Animation<double> pulseT;

  const RuleSummaryStrip({
    super.key,
    required this.total,
    required this.active,
    required this.triggered,
    required this.errors,
    required this.totalFires,
    required this.glowT,
    required this.pulseT,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowT, pulseT]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColors.bgCard.withOpacity(0.88),
          border: Border.all(
            color: AppColors.violet.withOpacity(0.2 + glowT.value * 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.violet.withOpacity(0.05),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            SumKpi(
              '$total',
              'TOTAL',
              AppColors.violet,
              Icons.account_tree_rounded,
            ),
            VDiv(),
            SumKpi(
              '$active',
              'ACTIVE',
              AppColors.green,
              Icons.play_circle_outline_rounded,
            ),
            VDiv(),
            SumKpi(
              '$triggered',
              'TRIGGERED',
              AppColors.amber,
              Icons.bolt_rounded,
            ),
            VDiv(),
            SumKpi(
              '$errors',
              'ERRORS',
              AppColors.red,
              Icons.error_outline_rounded,
            ),
            VDiv(),
            SumKpi(
              '$totalFires',
              'TOTAL FIRES',
              kAccent,
              Icons.flash_on_rounded,
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
                    color: AppColors.violet.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.violet.withOpacity(
                        0.3 + glowT.value * 0.15,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.memory_rounded,
                    color: AppColors.violet.withOpacity(
                      0.7 + glowT.value * 0.3,
                    ),
                    size: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ENGINE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    letterSpacing: 1.5,
                    color: AppColors.violet.withOpacity(
                      0.7 + glowT.value * 0.2,
                    ),
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
