import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/consumption_analytics/kpi_box.dart';

typedef C = AppColors;

/// A single KPI box in the strip
class KpiBoxData {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  final bool blink;

  KpiBoxData({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    this.blink = false,
  });
}

/// Vertical divider between KPI boxes
class VDiv extends StatelessWidget {
  const VDiv({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}

/// Reusable KPI strip
class KpiStrip extends StatelessWidget {
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final bool showCostMode;
  final double totalKWh;
  final double totalCost;
  final double changeVsPrev;
  final double peakKWh;
  final double avgKWh;
  final int anomalyCount;

  const KpiStrip({
    super.key,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.showCostMode,
    required this.totalKWh,
    required this.totalCost,
    required this.changeVsPrev,
    required this.peakKWh,
    required this.avgKWh,
    required this.anomalyCount,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.9),
          border: Border.all(
            color: C.amber.withOpacity(0.18 + glowCtrl.value * 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: C.amber.withOpacity(0.05 + glowCtrl.value * 0.02),
              blurRadius: 18,
            ),
          ],
        ),
        child: Row(
          children: [
            KpiBox(
              label: showCostMode ? 'TOTAL COST' : 'TOTAL CONSUMPTION',
              value: showCostMode
                  ? '\$${totalCost.toStringAsFixed(0)}'
                  : '${(totalKWh / 1000).toStringAsFixed(1)}',
              unit: showCostMode ? '' : 'MWh',
              color: C.amber,
              glow: glowCtrl.value,
              icon: showCostMode
                  ? Icons.attach_money_rounded
                  : Icons.electric_bolt_rounded,
            ),
            const VDiv(),
            KpiBox(
              label: 'VS PREV PERIOD',
              value:
                  '${changeVsPrev >= 0 ? '+' : ''}${changeVsPrev.toStringAsFixed(1)}',
              unit: '%',
              color: changeVsPrev > 5
                  ? C.red
                  : changeVsPrev < -2
                  ? C.green
                  : C.amber,
              glow: glowCtrl.value,
              blink: changeVsPrev > 8,
              blinkT: blinkCtrl.value,
              icon: changeVsPrev >= 0
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
            ),
            const VDiv(),
            KpiBox(
              label: 'PEAK DEMAND',
              value: '${(peakKWh / 1000).toStringAsFixed(2)}',
              unit: 'MW',
              color: C.red,
              glow: glowCtrl.value,
              icon: Icons.speed_rounded,
            ),
            const VDiv(),
            KpiBox(
              label: 'AVG LOAD',
              value: '${(avgKWh / 1000).toStringAsFixed(2)}',
              unit: 'MW',
              color: C.cyan,
              glow: glowCtrl.value,
              icon: Icons.bar_chart_rounded,
            ),
            const VDiv(),
            KpiBox(
              label: 'ANOMALIES',
              value: '$anomalyCount',
              unit: 'ACTIVE',
              color: anomalyCount > 0 ? C.orange : C.mutedLt,
              glow: glowCtrl.value,
              blink: anomalyCount > 0,
              blinkT: blinkCtrl.value,
              icon: Icons.auto_graph_rounded,
            ),
            const VDiv(),
            KpiBox(
              label: 'EFFICIENCY',
              value:
                  '${(100 - (changeVsPrev.abs() * 0.4)).clamp(72, 99).toStringAsFixed(0)}',
              unit: '%',
              color: C.teal,
              glow: glowCtrl.value,
              icon: Icons.eco_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
