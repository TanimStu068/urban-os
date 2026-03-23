import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/district_analytics_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_analytics/comparison_bar_painter.dart';
import 'package:urban_os/widgets/district_analytics/radar_axis.dart';

class ComparisonChart extends StatelessWidget {
  final DistrictModel d;
  final DistrictProvider dp;
  final List<RadarAxis> axes;
  final Animation<double> drawAnim;

  const ComparisonChart({
    super.key,
    required this.d,
    required this.dp,
    required this.axes,
    required this.drawAnim,
  });

  @override
  Widget build(BuildContext context) {
    final cityAxes = buildCityAverageAxes(dp);
    if (cityAxes.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: AnimatedBuilder(
        animation: drawAnim,
        builder: (_, __) => CustomPaint(
          painter: ComparisonBarPainter(axes, cityAxes, drawAnim.value),
        ),
      ),
    );
  }
}
