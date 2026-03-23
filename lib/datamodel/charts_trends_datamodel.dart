// DATA MODELS
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

enum TrendPeriod { h6, h24, d7, d30 }

enum MetricType { alerts, events, triggers, throughput }

extension TrendPeriodX on TrendPeriod {
  String get label => const ['6H', '24H', '7D', '30D'][index];
  int get buckets => const [6, 24, 7, 30][index];
  String get unit => index < 2 ? 'h' : 'd';
}

extension MetricTypeX on MetricType {
  String get label =>
      const ['ALERTS', 'EVENTS', 'TRIGGERS', 'THROUGHPUT'][index];
  Color get color =>
      [AppColors.red, AppColors.cyan, AppColors.amber, AppColors.green][index];
  IconData get icon => [
    Icons.warning_amber_rounded,
    Icons.bolt_rounded,
    Icons.play_arrow_rounded,
    Icons.speed_rounded,
  ][index];
}

class DataPoint {
  final int bucket;
  final double value;
  const DataPoint(this.bucket, this.value);
}

class SeriesData {
  final MetricType metric;
  final List<DataPoint> points;
  const SeriesData(this.metric, this.points);
  double get maxValue =>
      points.isEmpty ? 1 : points.map((p) => p.value).reduce(max);
  double get sum => points.fold(0, (a, b) => a + b.value);
  double get avg => points.isEmpty ? 0 : sum / points.length;
  double get last => points.isEmpty ? 0 : points.last.value;
  double get trend {
    if (points.length < 2) return 0;
    final half = points.length ~/ 2;
    final first =
        points.take(half).map((p) => p.value).reduce((a, b) => a + b) / half;
    final sec =
        points.skip(half).map((p) => p.value).reduce((a, b) => a + b) /
        (points.length - half);
    return first == 0 ? 0 : (sec - first) / first * 100;
  }
}
