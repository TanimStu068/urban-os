import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';

import 'package:urban_os/widgets/pollution_analytics/pollution_trend_analysis.dart';

typedef C = AppColors;

/// Trend chart panel widget
class PollutionTrendPanel extends StatelessWidget {
  final PollutantType selectedPollutant;
  final List<PollutionDataPoint> hourlyData;
  final AnimationController glowCtrl;
  final AnimationController barAnimCtrl;

  const PollutionTrendPanel({
    super.key,
    required this.selectedPollutant,
    required this.hourlyData,
    required this.glowCtrl,
    required this.barAnimCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'HOURLY TREND (24H)',
      icon: Icons.show_chart_rounded,
      color: selectedPollutant.color,
      child: SizedBox(
        height: 160,
        child: AnimatedBuilder(
          animation: Listenable.merge([glowCtrl, barAnimCtrl]),
          builder: (_, __) => CustomPaint(
            painter: PollutionTrendPainter(
              data: hourlyData,
              pollutantType: selectedPollutant,
              glow: glowCtrl.value,
              safeLimit: selectedPollutant.safeLimit,
            ),
            size: const Size(double.infinity, 160),
          ),
        ),
      ),
    );
  }
}
