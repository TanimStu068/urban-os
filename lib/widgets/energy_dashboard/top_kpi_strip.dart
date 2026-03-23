import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/top_kpi.dart';
import 'package:urban_os/widgets/energy_dashboard/vdivider.dart';
import 'package:urban_os/widgets/energy_dashboard/mini_donut.dart';

typedef C = AppColors;

class TopKpiStrip extends StatelessWidget {
  final double totalConsumption;
  final double totalGeneration;
  final double gridLoadPct;
  final double renewablePct;
  final int criticalZones;
  final List<EnergySourceModel> sources;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  const TopKpiStrip({
    super.key,
    required this.totalConsumption,
    required this.totalGeneration,
    required this.gridLoadPct,
    required this.renewablePct,
    required this.criticalZones,
    required this.sources,
    required this.glowAnimation,
    required this.blinkAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowAnimation, blinkAnimation]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.9),
          border: Border.all(
            color: C.amber.withOpacity(0.18 + glowAnimation.value * 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: C.amber.withOpacity(0.06 + glowAnimation.value * 0.03),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            TopKpi(
              label: 'CONSUMPTION',
              value: '${(totalConsumption / 1000).toStringAsFixed(1)}',
              unit: 'MW',
              icon: Icons.electric_bolt_rounded,
              color: C.amber,
              glow: glowAnimation.value,
            ),
            VDivider(),
            TopKpi(
              label: 'GENERATION',
              value: '${(totalGeneration / 1000).toStringAsFixed(1)}',
              unit: 'MW',
              icon: Icons.power_rounded,
              color: C.green,
              glow: glowAnimation.value,
            ),
            VDivider(),
            TopKpi(
              label: 'GRID LOAD',
              value: gridLoadPct.toStringAsFixed(1),
              unit: '%',
              icon: Icons.speed_rounded,
              color: gridLoadPct > 90
                  ? C.red
                  : gridLoadPct > 75
                  ? C.amber
                  : C.green,
              glow: glowAnimation.value,
              blink: gridLoadPct > 90,
              blinkT: blinkAnimation.value,
            ),
            VDivider(),
            TopKpi(
              label: 'RENEWABLE',
              value: renewablePct.toStringAsFixed(0),
              unit: '%',
              icon: Icons.eco_rounded,
              color: C.teal,
              glow: glowAnimation.value,
            ),
            VDivider(),
            TopKpi(
              label: 'CRITICAL',
              value: '$criticalZones',
              unit: 'ZONES',
              icon: Icons.error_outline_rounded,
              color: criticalZones > 0 ? C.red : C.mutedLt,
              glow: glowAnimation.value,
              blink: criticalZones > 0,
              blinkT: blinkAnimation.value,
            ),
            VDivider(),
            MiniDonut(
              sources: sources,
              totalGen: totalGeneration,
              glowT: glowAnimation.value,
            ),
          ],
        ),
      ),
    );
  }
}
