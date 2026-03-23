import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/district_analytics_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_analytics/analysis_section_header.dart';
import 'package:urban_os/widgets/district_analytics/bar_chart_painter.dart';
import 'package:urban_os/widgets/district_analytics/comparison_chart.dart';
import 'package:urban_os/widgets/district_analytics/radar_chart_painter.dart';

class ChartPanel extends StatelessWidget {
  final DistrictModel d;
  final DistrictProvider dp;

  final Animation<double> drawAnim;
  final Animation<double> pulseAnim;

  final int viewMode;

  const ChartPanel({
    super.key,
    required this.d,
    required this.dp,
    required this.drawAnim,
    required this.pulseAnim,
    required this.viewMode,
  });

  @override
  Widget build(BuildContext context) {
    final axes = buildRadarAxes(d);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        children: [
          /// 🔥 Header
          Row(
            children: [
              const AnalysisSectionHeader('MULTI-DIMENSION ANALYSIS', C.violet),
              const Spacer(),
              if (d.metrics.lastUpdated != null)
                Text(
                  'UPD ${ago(d.metrics.lastUpdated!)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.mutedLt,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          /// 📊 Chart switcher
          AnimatedBuilder(
            animation: drawAnim,
            builder: (_, __) {
              if (viewMode == 0) {
                /// 🕸 Radar Chart
                return SizedBox(
                  height: 240,
                  child: CustomPaint(
                    painter: RadarChartPainter(
                      axes,
                      drawAnim.value,
                      pulseAnim.value,
                    ),
                  ),
                );
              } else if (viewMode == 1) {
                /// 📊 Bar Chart
                return SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: BarChartPainter(axes, drawAnim.value),
                  ),
                );
              } else {
                /// ⚖️ Comparison Chart
                return ComparisonChart(
                  d: d,
                  dp: dp,
                  axes: axes,
                  drawAnim: drawAnim,
                );
              }
            },
          ),

          const SizedBox(height: 10),

          /// 🎯 Legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: axes.map((a) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: a.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    a.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: a.color,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
