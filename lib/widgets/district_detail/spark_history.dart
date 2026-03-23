import 'package:flutter/material.dart';

import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/district_detail/spark_painter.dart';

typedef C = AppColors;

class SparkHistory extends StatelessWidget {
  final DistrictModel d;

  const SparkHistory({super.key, required this.d});

  List<double> _generateData() {
    return List.generate(24, (i) {
      final base = d.healthPercentage;
      return base +
          sin(i * 0.4) * 8 +
          Random(d.id.hashCode + i).nextDouble() * 6 -
          2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateData();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '24H HEALTH TREND',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.mutedLt,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: CustomPaint(painter: SparkPainter(data, C.cyan)),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '24h ago',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.mutedLt,
                ),
              ),
              Text(
                'NOW',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.cyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
