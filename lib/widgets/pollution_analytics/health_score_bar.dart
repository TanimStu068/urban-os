import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'package:urban_os/widgets/pollution_analytics/health_score_painter.dart';

typedef C = AppColors;

class HealthScoreBar extends StatelessWidget {
  final double healthScore;
  final double avgPollutant;
  final double maxPollutant;
  final PollutantType selectedPollutant;

  final AnimationController glowCtrl;
  final AnimationController barAnimCtrl;

  const HealthScoreBar({
    super.key,
    required this.healthScore,
    required this.avgPollutant,
    required this.maxPollutant,
    required this.selectedPollutant,
    required this.glowCtrl,
    required this.barAnimCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, barAnimCtrl]),
      builder: (_, __) {
        return Container(
          margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(0.9),
            border: Border.all(color: C.orange.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: C.orange.withOpacity(0.05 + glowCtrl.value * 0.02),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            children: [
              // Gauge
              SizedBox(
                width: 48,
                height: 48,
                child: CustomPaint(
                  painter: HealthScorePainter(
                    score: healthScore,
                    glow: glowCtrl.value,
                    selectedColor: selectedPollutant.color,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Score text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      healthScore.toStringAsFixed(0),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: selectedPollutant.color,
                        shadows: [
                          Shadow(color: selectedPollutant.color, blurRadius: 8),
                        ],
                      ),
                    ),
                    const Text(
                      'HEALTH SCORE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        color: C.mutedLt,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'AVG: ${avgPollutant.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: selectedPollutant.color,
                    ),
                  ),
                  Text(
                    'PEAK: ${maxPollutant.toStringAsFixed(1)} ${selectedPollutant.unit}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
