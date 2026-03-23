import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';

class MetricCard extends StatelessWidget {
  final PerformanceMetric metric;

  const MetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final progress = metric.threshold != null
        ? (metric.value / metric.threshold!).clamp(0, 1)
        : 0.5;
    final isWarning = progress > 0.8 || metric.isWarning;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(
          color: (isWarning ? C.orange : C.teal).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric.name,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${metric.value.toStringAsFixed(1)} ${metric.unit}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: isWarning ? C.orange : C.teal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 4,
              backgroundColor: isWarning
                  ? C.orange.withOpacity(0.1)
                  : C.teal.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(isWarning ? C.orange : C.teal),
            ),
          ),
        ],
      ),
    );
  }
}
