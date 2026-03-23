import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';
import 'package:urban_os/widgets/chartsTrends/axis_label.dart';
import 'package:urban_os/widgets/chartsTrends/line_chart_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MainChartWidget extends StatelessWidget {
  final List<SeriesData> activeSeries;
  final Animation<double> drawAnimation;
  final TrendPeriod period;
  final int? hoverBucket;
  final void Function(int?) onHoverBucketChanged;

  const MainChartWidget({
    super.key,
    required this.activeSeries,
    required this.drawAnimation,
    required this.period,
    required this.hoverBucket,
    required this.onHoverBucketChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (activeSeries.isEmpty) return const SizedBox(height: 220);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chart header
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                children: [
                  Text(
                    'TIME SERIES',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.mutedLt,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'TAP TO INSPECT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.mutedLt,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            // Chart area
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: drawAnimation,
                builder: (_, __) => GestureDetector(
                  onTapDown: (d) {
                    final box = context.findRenderObject() as RenderBox?;
                    if (box == null) return;
                    final localX = d.localPosition.dx - 40;
                    final chartW = box.size.width - 80.0;
                    final buckets = period.buckets;
                    final b = (localX / chartW * buckets)
                        .clamp(0, buckets - 1)
                        .toInt();
                    onHoverBucketChanged(b == hoverBucket ? null : b);
                  },
                  child: CustomPaint(
                    painter: LineChartPainter(
                      activeSeries,
                      drawAnimation.value,
                      hoverBucket,
                      period.buckets,
                    ),
                  ),
                ),
              ),
            ),
            // X-axis labels
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: ChartXAxisLabelsWidget(
                buckets: period.buckets,
                period: period,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
