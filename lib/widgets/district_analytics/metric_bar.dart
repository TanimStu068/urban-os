import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/district_analytics/analysis_section_header.dart';

typedef C = AppColors;

class MetricBars extends StatelessWidget {
  final DistrictModel d;
  final Animation<double> drawAnim;

  const MetricBars({super.key, required this.d, required this.drawAnim});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('TRAFFIC LOAD', d.metrics.averageTraffic, 100.0, C.amber, true),
      ('SAFETY SCORE', d.metrics.safetyScore, 100.0, C.green, false),
      (
        'AIR QUALITY IDX',
        d.metrics.airQualityIndex.clamp(0, 500),
        500.0,
        C.cyan,
        true,
      ),
      (
        'ENERGY (MWh)',
        d.metrics.energyConsumption.clamp(0, 1000),
        1000.0,
        C.amber,
        true,
      ),
      if (d.metrics.satisfactionScore != null)
        ('SATISFACTION', d.metrics.satisfactionScore!, 100.0, C.violet, false),
      if (d.metrics.greenSpacePercentage != null)
        ('GREEN SPACE', d.metrics.greenSpacePercentage!, 100.0, C.green, false),
      if (d.metrics.renewableEnergyPercent != null)
        (
          'RENEWABLE %',
          d.metrics.renewableEnergyPercent!,
          100.0,
          C.green,
          false,
        ),
      if (d.metrics.noiseLevelDb != null)
        ('NOISE LEVEL dB', d.metrics.noiseLevelDb!, 120.0, C.red, true),
    ];

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
          const AnalysisSectionHeader('METRIC BREAKDOWN', C.cyan),
          const SizedBox(height: 12),

          ...metrics.map((m) {
            final frac = (m.$2 / m.$3).clamp(0.0, 1.0);
            final col = m.$4;

            return AnimatedBuilder(
              animation: drawAnim,
              builder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          m.$1,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: col,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          m.$2.toStringAsFixed(m.$2 < 10 ? 1 : 0),
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 11,
                            color: col,
                          ),
                        ),
                        Text(
                          ' / ${m.$3.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.mutedLt,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Stack(
                      children: [
                        Container(
                          height: 7,
                          decoration: BoxDecoration(
                            color: col.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),

                        /// 🔥 Animated fill
                        FractionallySizedBox(
                          widthFactor: frac * drawAnim.value,
                          child: Container(
                            height: 7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  col.withValues(alpha: 0.5),
                                  col.withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),

                        /// 📍 Threshold marker (70%)
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 1,
                              height: 10,
                              color: C.mutedLt.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
