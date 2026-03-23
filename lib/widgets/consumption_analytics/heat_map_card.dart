import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/heat_map_painter.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';

typedef C = AppColors;

class HeatmapCard extends StatelessWidget {
  // final List<List<double>> cells; // your heatmap data
  final List<HourlyHeatmapCell> cells;

  final AnimationController glowCtrl;

  const HeatmapCard({super.key, required this.cells, required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'WEEKLY HOURLY HEATMAP',
      icon: Icons.grid_4x4_rounded,
      color: C.orange,
      badge: '7D × 24H',
      badgeColor: C.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: HeatmapPainter(cells: cells, glowT: glowCtrl.value),
                size: const Size(double.infinity, 140),
              ),
            ),
          ),
          const SizedBox(height: 6),
          _buildLegend(),
        ],
      ),
    );
  }

  /// ---------------- LEGEND ----------------
  Widget _buildLegend() {
    return Row(
      children: [
        const Text(
          'LOW',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.mutedLt,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: const LinearGradient(
                colors: [C.bgCard2, C.teal, C.amber, C.red],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'HIGH',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.mutedLt,
          ),
        ),
      ],
    );
  }
}
