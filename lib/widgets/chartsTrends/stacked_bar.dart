import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';
import 'package:urban_os/widgets/chartsTrends/stack_bar_painter.dart';

typedef C = AppColors;

class StackedActivityWidget extends StatelessWidget {
  final List<SeriesData> activeSeries;
  final Animation<double> drawAnimation;
  final int? hoverBucket;
  final String periodLabel;

  const StackedActivityWidget({
    super.key,
    required this.activeSeries,
    required this.drawAnimation,
    required this.hoverBucket,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (activeSeries.isEmpty) return const SizedBox(height: 16);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'STACKED ACTIVITY',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: C.mutedLt,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '$periodLabel WINDOW',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: drawAnimation,
              builder: (_, __) => SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: StackedBarPainter(
                    activeSeries,
                    drawAnimation.value,
                    hoverBucket,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
