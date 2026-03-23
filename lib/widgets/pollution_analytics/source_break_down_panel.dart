import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/pollution_analytics/pie_chart_painter.dart';

typedef C = AppColors;

/// Pollution sources breakdown panel
class SourceBreakdownPanel extends StatelessWidget {
  final List<PollutionSource> sources;
  final AnimationController glowCtrl;

  const SourceBreakdownPanel({
    super.key,
    required this.sources,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'POLLUTION SOURCES',
      icon: Icons.pie_chart_rounded,
      color: C.lime,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: PieChartPainter(
                  sources: sources,
                  glow: glowCtrl.value,
                ),
                size: const Size(double.infinity, 140),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Column(
            children: sources.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s.color,
                        boxShadow: [
                          BoxShadow(
                            color: s.color.withOpacity(0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.white,
                        ),
                      ),
                    ),
                    Text(
                      '${s.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: s.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
