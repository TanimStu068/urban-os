import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_analytics_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/district_analytics/analysis_section_header.dart';

typedef C = AppColors;

class InsightsPanel extends StatelessWidget {
  final DistrictModel d;

  const InsightsPanel({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    final insights = generateInsights(d);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisSectionHeader('AI INSIGHTS', C.cyan),
          const SizedBox(height: 12),
          ...insights.map(
            (ins) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ins.$3.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: ins.$3.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: ins.$3.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ins.$3.withValues(alpha: 0.3)),
                    ),
                    child: Icon(ins.$2, color: ins.$3, size: 13),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ins.$1,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: ins.$3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ins.$4,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.mutedLt,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
