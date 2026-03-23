import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/widgets/district_detail/compact_bar.dart';
import 'package:urban_os/widgets/district_detail/hero_metrict.dart';
import 'package:urban_os/widgets/district_detail/large_dial_painter.dart';
import 'package:urban_os/widgets/district_detail/status_pill.dart';

typedef C = AppColors;

class HeroCard extends StatelessWidget {
  final DistrictModel district;
  final Animation<double> glowAnim;
  final Animation<double> pulseAnim;
  final Color Function(double) healthColor;
  final Color Function(dynamic) typeColor;
  final Color Function(int) aqiColor;

  const HeroCard({
    super.key,
    required this.district,
    required this.glowAnim,
    required this.pulseAnim,
    required this.healthColor,
    required this.typeColor,
    required this.aqiColor,
  });

  @override
  Widget build(BuildContext context) {
    final health = district.healthPercentage;
    final healthCol = healthColor(health);
    final typeCol = typeColor(district.type);

    return AnimatedBuilder(
      animation: Listenable.merge([glowAnim, pulseAnim]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: typeCol.withOpacity(0.25 + glowAnim.value * 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: typeCol.withOpacity(0.04 + glowAnim.value * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Health dial
            SizedBox(
              width: 72,
              height: 72,
              child: AnimatedBuilder(
                animation: pulseAnim,
                builder: (_, __) => CustomPaint(
                  painter: LargeDialPainter(
                    health / 100,
                    healthCol,
                    pulseAnim.value,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${health.toInt()}',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            color: healthCol,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'HEALTH',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6,
                            color: healthCol.withOpacity(0.7),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Metrics & tags column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: metrics
                  Row(
                    children: [
                      HeroMetric(
                        'TRAFFIC',
                        '${district.metrics.averageTraffic.toInt()}%',
                        C.amber,
                        Icons.traffic_rounded,
                      ),
                      const SizedBox(width: 10),
                      HeroMetric(
                        'SAFETY',
                        '${district.metrics.safetyScore.toInt()}',
                        C.green,
                        Icons.security_rounded,
                      ),
                      const SizedBox(width: 10),
                      // HeroMetric(
                      //   'AQI',
                      //   district.metrics.airQualityIndex.toInt().toString(),
                      //   aqiColor(district.metrics.airQualityIndex),
                      //   Icons.air_rounded,
                      // ),
                      HeroMetric(
                        'AQI',
                        district.metrics.airQualityIndex.toInt().toString(),
                        aqiColor(district.metrics.airQualityIndex.toInt()),
                        Icons.air_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Bar row
                  Row(
                    children: [
                      CompactBar(
                        'ENERGY',
                        district.metrics.energyConsumption,
                        500,
                        C.amber,
                      ),
                      const SizedBox(width: 8),
                      if (district.metrics.waterConsumption != null)
                        CompactBar(
                          'WATER',
                          district.metrics.waterConsumption!,
                          1000,
                          C.cyan,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags row
                  Row(
                    children: [
                      if (district.isActive) StatusPill('ONLINE', C.green),
                      if (!district.isActive) StatusPill('OFFLINE', C.red),
                      const SizedBox(width: 6),
                      StatusPill(district.type.primaryConcern, typeCol),
                      if (district.metrics.activeIncidents > 0) ...[
                        const SizedBox(width: 6),
                        StatusPill(
                          '${district.metrics.activeIncidents} INC',
                          C.red,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
