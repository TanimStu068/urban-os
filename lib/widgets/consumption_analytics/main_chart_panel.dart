import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/hover_tool_tip.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';
import 'package:urban_os/widgets/consumption_analytics/chip_btn.dart';
import 'package:urban_os/widgets/consumption_analytics/legend_dot.dart';
import 'package:urban_os/widgets/consumption_analytics/break_down_donut_card.dart';
import 'package:urban_os/widgets/consumption_analytics/main_chart_painter.dart';

typedef C = AppColors;

class MainChartPanel extends StatefulWidget {
  final List<ConsumptionPoint> series;
  final List<CategoryData> categories;
  final ChartMode chartMode;
  final TimeRange range;
  final AnimationController glowCtrl;
  final Animation<double> chartAnim;
  final bool showCostMode;

  const MainChartPanel({
    super.key,
    required this.series,
    required this.categories,
    required this.chartMode,
    required this.range,
    required this.glowCtrl,
    required this.chartAnim,
    this.showCostMode = false,
  });

  @override
  State<MainChartPanel> createState() => _MainChartPanelState();
}

class _MainChartPanelState extends State<MainChartPanel> {
  bool _compareEnabled = false;
  bool _showForecast = false;
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: _getTitle(),
      icon: Icons.show_chart_rounded,
      color: C.amber,
      badge: widget.range.label,
      badgeColor: C.amber,
      actions: [
        if (widget.chartMode != ChartMode.breakdown) ...[
          ChipBtn(
            'COMPARE',
            _compareEnabled,
            () => setState(() => _compareEnabled = !_compareEnabled),
            C.cyan,
          ),
          const SizedBox(width: 6),
          ChipBtn(
            'FORECAST',
            _showForecast,
            () => setState(() => _showForecast = !_showForecast),
            C.violet,
          ),
        ],
      ],
      child: Column(
        children: [
          if (widget.chartMode == ChartMode.breakdown)
            BreakdownDonutCard(
              categories: widget.categories,
              glowCtrl: widget.glowCtrl,
              barAnim: widget.chartAnim,
            )
          else ...[
            SizedBox(
              height: 170,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  widget.glowCtrl,
                  widget.chartAnim,
                ]),
                builder: (_, __) => GestureDetector(
                  onTapUp: (details) {
                    final fraction =
                        details.localPosition.dx /
                        (MediaQuery.of(context).size.width - 56);
                    final idx = (fraction * widget.series.length)
                        .clamp(0, widget.series.length - 1)
                        .toInt();
                    setState(() => _hoverIndex = idx);
                  },
                  child: CustomPaint(
                    painter: MainChartPainter(
                      series: widget.series,
                      range: widget.range,
                      mode: widget.chartMode,
                      showCompare: _compareEnabled,
                      showForecast: _showForecast,
                      showCost: widget.showCostMode,
                      animT: widget.chartAnim.value,
                      glowT: widget.glowCtrl.value,
                      hoverIdx: _hoverIndex,
                    ),
                    size: const Size(double.infinity, 170),
                  ),
                ),
              ),
            ),
            // Hover tooltip
            if (_hoverIndex >= 0 && _hoverIndex < widget.series.length) ...[
              const SizedBox(height: 8),
              HoverTooltip(
                point: widget.series[_hoverIndex],
                index: _hoverIndex,
                xLabel: widget.range.xLabel(_hoverIndex),
                compareEnabled: _compareEnabled,
                showForecast: _showForecast,
              ),
            ],
            const SizedBox(height: 6),
            // Legend
            Row(
              children: [
                LegendDot('CONSUMPTION', C.amber),
                if (_compareEnabled) ...[
                  const SizedBox(width: 12),
                  LegendDot('PREV PERIOD', C.cyan.withOpacity(0.7)),
                ],
                if (_showForecast) ...[
                  const SizedBox(width: 12),
                  LegendDot('FORECAST', C.violet),
                ],
                const SizedBox(width: 12),
                LegendDot('ANOMALY', C.red),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getTitle() {
    switch (widget.chartMode) {
      case ChartMode.consumption:
        return 'LOAD CURVE';
      case ChartMode.comparison:
        return 'PERIOD COMPARISON';
      case ChartMode.forecast:
        return 'CONSUMPTION FORECAST';
      case ChartMode.breakdown:
        return 'CATEGORY BREAKDOWN';
    }
  }
}
