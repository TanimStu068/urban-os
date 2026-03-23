import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/spark_fill.dart';

typedef C = AppColors;

class PollutantRowCard extends StatelessWidget {
  final Pollutant pollutant;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController barAnim;

  const PollutantRowCard({
    super.key,
    required this.pollutant,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedBuilder(
        animation: Listenable.merge([glowCtrl, blinkCtrl, barAnim]),
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pollutant.color.withOpacity(0.12),
                    border: Border.all(color: pollutant.color.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      pollutant.id.substring(0, min(2, pollutant.id.length)),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: pollutant.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            pollutant.name,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: pollutant.color,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${pollutant.value.toStringAsFixed(1)} ${pollutant.unit}',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: pollutant.isOverLimit
                                  ? pollutant.color
                                  : C.white,
                              fontWeight: pollutant.isOverLimit
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (pollutant.isOverLimit)
                            AnimatedBuilder(
                              animation: blinkCtrl,
                              builder: (_, __) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: pollutant.color.withOpacity(
                                    0.12 + blinkCtrl.value * 0.05,
                                  ),
                                  border: Border.all(
                                    color: pollutant.color.withOpacity(
                                      0.4 + blinkCtrl.value * 0.15,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'OVER LIMIT',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 6.5,
                                    color: pollutant.color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Stack(
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: C.bgCard2,
                              border: Border.all(color: C.gBdr),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (pollutant.pct / 200 * barAnim.value)
                                .clamp(0, 1),
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: pollutant.isOverLimit
                                      ? [
                                          pollutant.color.withOpacity(0.7),
                                          pollutant.color,
                                        ]
                                      : [
                                          pollutant.color.withOpacity(0.4),
                                          pollutant.color.withOpacity(0.6),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: pollutant.color.withOpacity(
                                      pollutant.isOverLimit
                                          ? 0.35 + glowCtrl.value * 0.15
                                          : 0.15,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Safe limit marker
                          Positioned(
                            left:
                                49.9 *
                                    (MediaQuery.of(context).size.width - 80) /
                                    100 -
                                1,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1.5,
                              color: C.white.withOpacity(0.3),
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'LIMIT: ${pollutant.safeLimit.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 6.5,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 24,
              child: CustomPaint(
                painter: SparkFill(
                  data: pollutant.history,
                  color: pollutant.color,
                  glow: glowCtrl.value,
                  dangerLine: pollutant.safeLimit,
                ),
                size: const Size(double.infinity, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
