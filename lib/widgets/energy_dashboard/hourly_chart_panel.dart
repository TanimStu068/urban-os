import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/energy_dashboard/hourly_chart_painter.dart';

typedef C = AppColors;

class HourlyChartPanel extends StatelessWidget {
  final List<HourlyData> hourlyData;
  final Animation<double> glowAnimation;

  const HourlyChartPanel({
    super.key,
    required this.hourlyData,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: '24-HOUR LOAD PROFILE',
      icon: Icons.show_chart_rounded,
      color: C.cyan,
      badge: 'TODAY',
      badgeColor: C.cyan,
      child: SizedBox(
        height: 110,
        child: AnimatedBuilder(
          animation: glowAnimation,
          builder: (_, __) => CustomPaint(
            painter: HourlyChartPainter(
              data: hourlyData,
              glowT: glowAnimation.value,
            ),
            size: const Size(double.infinity, 110),
          ),
        ),
      ),
    );
  }
}
