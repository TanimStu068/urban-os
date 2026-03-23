import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

typedef C = AppColors;

class MetricToggles extends StatelessWidget {
  final List<SeriesData> series;
  final Set<MetricType> activeMetrics;
  final Function(MetricType) onToggleMetric;

  const MetricToggles({
    super.key,
    required this.series,
    required this.activeMetrics,
    required this.onToggleMetric,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: C.bgCard.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: MetricType.values.map((m) {
                  final active = activeMetrics.contains(m);
                  final s = series.firstWhere((s) => s.metric == m);

                  return GestureDetector(
                    onTap: () => onToggleMetric(m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? m.color.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: active ? m.color.withOpacity(0.4) : C.gBdr,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? m.color
                                  : C.mutedLt.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),

                          Text(
                            m.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              letterSpacing: 1,
                              color: active ? m.color : C.mutedLt,
                            ),
                          ),

                          const SizedBox(width: 5),

                          Text(
                            s.sum.toInt().toString(),
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 8,
                              color: active
                                  ? m.color.withOpacity(0.7)
                                  : C.mutedLt.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
