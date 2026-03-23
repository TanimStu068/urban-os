import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';
import 'package:urban_os/widgets/developer_panel/metric_card.dart';

class MetricsView extends StatelessWidget {
  final List<PerformanceMetric> metrics;

  const MetricsView({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: metrics
            .map(
              (metric) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MetricCard(metric: metric),
              ),
            )
            .toList(),
      ),
    );
  }
}
