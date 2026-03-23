import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_list/vdiv.dart';
import 'package:urban_os/widgets/district_list/sum_kpi.dart';

typedef C = AppColors;

class KpiRow extends StatelessWidget {
  final DistrictProvider districtProvider;
  final Animation<double> glowAnimation;

  const KpiRow({
    super.key,
    required this.districtProvider,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final avg = districtProvider.averageHealthScore;
    final incidents = districtProvider.totalActiveIncidents;
    final critical = districtProvider.criticalDistrictCount;
    final total = districtProvider.totalDistricts;

    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        color: C.bgCard.withOpacity(0.88),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            SumKpi(
              '$total',
              'TOTAL',
              C.cyan,
              Icons.grid_view_rounded,
              glowAnimation.value,
            ),
            VDiv(),
            SumKpi(
              '${avg.toStringAsFixed(1)}%',
              'AVG HEALTH',
              C.green,
              Icons.health_and_safety_rounded,
              glowAnimation.value,
            ),
            VDiv(),
            SumKpi(
              '$incidents',
              'INCIDENTS',
              C.amber,
              Icons.report_rounded,
              glowAnimation.value,
            ),
            VDiv(),
            SumKpi(
              '$critical',
              'CRITICAL',
              C.red,
              Icons.warning_amber_rounded,
              glowAnimation.value,
            ),
          ],
        ),
      ),
    );
  }
}
