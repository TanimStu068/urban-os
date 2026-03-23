import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/hourly_trend_painter.dart';

typedef C = AppColors;

class HourlyOverviewChart extends StatelessWidget {
  final List<HourlyEnvPoint> hourlyData;
  final AnimationController glowCtrl;

  const HourlyOverviewChart({
    super.key,
    required this.hourlyData,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: '24H ENVIRONMENTAL TRENDS',
      icon: Icons.show_chart_rounded,
      color: C.cyan,
      badge: 'TODAY',
      badgeColor: C.cyan,
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: HourlyTrendPainter(
                  data: hourlyData,
                  glow: glowCtrl.value,
                ),
                size: const Size(double.infinity, 130),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegDot('TEMP', C.amber),
              SizedBox(width: 12),
              _LegDot('HUMIDITY', C.cyan),
              SizedBox(width: 12),
              _LegDot('AQI', C.teal),
              SizedBox(width: 12),
              _LegDot('RAINFALL', C.sky),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple legend dot widget
class _LegDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegDot(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8.5,
            color: C.white,
          ),
        ),
      ],
    );
  }
}
