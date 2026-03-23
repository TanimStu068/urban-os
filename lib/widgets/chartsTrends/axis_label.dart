import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

typedef C = AppColors;

class ChartXAxisLabelsWidget extends StatelessWidget {
  final int buckets;
  final TrendPeriod period;

  const ChartXAxisLabelsWidget({
    super.key,
    required this.buckets,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final labels = <String>[];

    for (int i = 0; i < buckets; i++) {
      if (i % max(1, buckets ~/ 6) != 0) {
        labels.add('');
        continue;
      }

      if (period.index < 2) {
        final h = now.subtract(Duration(hours: buckets - 1 - i));
        labels.add('${h.hour.toString().padLeft(2, '0')}:00');
      } else {
        final d = now.subtract(Duration(days: buckets - 1 - i));
        labels.add('${d.month}/${d.day}');
      }
    }

    return Row(
      children: List.generate(
        buckets,
        (i) => Expanded(
          child: Text(
            labels[i],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5,
              color: C.mutedLt,
            ),
          ),
        ),
      ),
    );
  }
}
