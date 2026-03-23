import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/main_chart_panel.dart';
import 'package:urban_os/widgets/consumption_analytics/heat_map_painter.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/consumption_analytics/peak_analysis_panel.dart';
import 'package:urban_os/widgets/consumption_analytics/energy_intensity_panel.dart';

typedef C = AppColors;

class OverviewTab extends StatelessWidget {
  final ScrollController scrollController;
  final List<ConsumptionPoint> series;
  final List<CategoryData> categories;
  final List<HourlyHeatmapCell> heatmap;
  final TimeRange range;
  final ChartMode chartMode;
  final bool showCostMode;
  final AnimationController glowCtrl;
  final Animation<double> chartAnim;
  final AnimationController blinkCtrl;

  const OverviewTab({
    super.key,
    required this.scrollController,
    required this.series,
    required this.categories,
    required this.heatmap,
    required this.range,
    required this.chartMode,
    required this.showCostMode,
    required this.glowCtrl,
    required this.chartAnim,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final peak = series.isNotEmpty
        ? series.map((p) => p.value).reduce(max)
        : 0.0;
    final avg = series.isNotEmpty
        ? series.map((p) => p.value).reduce((a, b) => a + b) / series.length
        : 0.0;

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainChartPanel(
            series: series,
            categories: categories,
            chartMode: chartMode,
            range: range,
            showCostMode: showCostMode,
            glowCtrl: glowCtrl,
            chartAnim: chartAnim,
          ),
          const SizedBox(height: 10),
          Panel(
            title: 'ENERGY HEATMAP',
            icon: Icons.heat_pump_rounded,
            color: C.cyan,
            child: SizedBox(
              height: 140,
              child: AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => CustomPaint(
                  painter: HeatmapPainter(
                    cells: heatmap,
                    glowT: glowCtrl.value,
                  ),
                  size: const Size(double.infinity, 140),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          PeakAnalysisPanel(
            peakKWh: peak,
            avgKWh: avg,
            glowCtrl: glowCtrl,
            series: series,
            range: range,
            buildSeries: (timeRange) => series,
          ),
          const SizedBox(height: 10),
          EnergyIntensityPanel(),
        ],
      ),
    );
  }
}
