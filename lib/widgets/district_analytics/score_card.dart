import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/district_analytics_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/district_analytics/score_dial_painter.dart';

class ScoreCard extends StatelessWidget {
  final DistrictModel d;

  final Animation<double> glowAnim;
  final Animation<double> pulseAnim;

  const ScoreCard({
    super.key,
    required this.d,
    required this.glowAnim,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    final axes = buildRadarAxes(d);
    final healthCol = healthColor(d.healthPercentage);

    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: healthCol.withValues(alpha: 0.22 + glowAnim.value * 0.06),
          ),
          boxShadow: [
            BoxShadow(color: healthCol.withValues(alpha: 0.04), blurRadius: 16),
          ],
        ),
        child: Row(
          children: [
            /// 🎯 Score Dial
            AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: ScoreDialPainter(
                    d.healthPercentage / 100,
                    healthCol,
                    pulseAnim.value,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${d.healthPercentage.toInt()}',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 17,
                            color: healthCol,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: healthCol.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// 📊 Top Metrics
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 8) / 2;

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: axes.take(4).map((a) {
                      return SizedBox(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  a.label,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 6.5,
                                    color: a.color,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(a.value * 100).toInt()}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 8,
                                    color: a.color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),

                            Stack(
                              children: [
                                Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: a.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: a.value,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: a.color.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
