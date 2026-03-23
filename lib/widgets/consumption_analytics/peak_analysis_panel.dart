import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/gauge_painter.dart';
import 'package:urban_os/widgets/consumption_analytics/matric_row.dart';
import 'package:urban_os/widgets/consumption_analytics/peak_hour_bar.dart';
import 'package:urban_os/widgets/consumption_analytics/sec_label.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';

typedef C = AppColors;

class PeakAnalysisPanel extends StatelessWidget {
  final double peakKWh;
  final double avgKWh;
  final AnimationController glowCtrl;
  final TimeRange range;

  final List<ConsumptionPoint> series;
  final List<ConsumptionPoint> Function(TimeRange) buildSeries;

  const PeakAnalysisPanel({
    super.key,
    required this.peakKWh,
    required this.avgKWh,
    required this.glowCtrl,
    required this.series,
    required this.range,
    required this.buildSeries,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'PEAK DEMAND ANALYSIS',
      icon: Icons.speed_rounded,
      color: C.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Peak gauge
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => SizedBox(
              height: 80,
              child: CustomPaint(
                painter: GaugePainter(
                  value: (peakKWh / (avgKWh * 2) * 100).clamp(0, 100),
                  color: C.red,
                  glowT: glowCtrl.value,
                ),
                size: const Size(double.infinity, 80),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Metrics
          MetricRow(
            'PEAK LOAD',
            '${(peakKWh / 1000).toStringAsFixed(2)} MW',
            C.red,
          ),
          MetricRow(
            'AVG LOAD',
            '${(avgKWh / 1000).toStringAsFixed(2)} MW',
            C.amber,
          ),
          MetricRow(
            'LOAD FACTOR',
            '${(avgKWh / peakKWh * 100).toStringAsFixed(1)}%',
            C.cyan,
          ),
          MetricRow(
            'PEAK / AVG',
            '${(peakKWh / avgKWh).toStringAsFixed(2)}×',
            C.violet,
          ),
          const SizedBox(height: 4),
          // Peak hours bar
          const SecLabel('DAILY PEAK WINDOW'),
          const SizedBox(height: 5),
          AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => SizedBox(
              height: 20,
              child: CustomPaint(
                painter: PeakHourBarPainter(
                  series: range == TimeRange.h24
                      ? series
                      : buildSeries(TimeRange.h24),
                  glowT: glowCtrl.value,
                ),
                size: const Size(double.infinity, 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
