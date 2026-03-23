import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';
import 'package:urban_os/widgets/city_health/hmetric.dart';

typedef C = AppColors;

class InfrastructureGrid extends StatelessWidget {
  final List<BuildingModel> buildings;
  final List<RoadModel> roads;
  final double infraHealth, congestion, bldRisk;
  final AnimationController glowCtrl;
  const InfrastructureGrid({
    super.key,
    required this.buildings,
    required this.roads,
    required this.infraHealth,
    required this.congestion,
    required this.bldRisk,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final riskBuildings = buildings
        .where((b) => b.riskLevel > 0.6)
        .take(4)
        .toList();
    final congRoads = roads
        .where((r) => r.congestionLevel > 0.65)
        .take(4)
        .toList();

    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'INFRASTRUCTURE STATUS',
            icon: Icons.route_rounded,
            color: C.violet,
          ),

          // Headline metrics
          Row(
            children: [
              HMetric(
                label: 'INFRA HEALTH',
                value: '${infraHealth.toStringAsFixed(0)}%',
                color: infraHealth >= 80
                    ? C.teal
                    : infraHealth >= 60
                    ? C.amber
                    : C.red,
              ),
              const SizedBox(width: 10),
              HMetric(
                label: 'CONGESTION',
                value: '${congestion.toStringAsFixed(0)}%',
                color: congestion < 50
                    ? C.teal
                    : congestion < 75
                    ? C.amber
                    : C.red,
              ),
              const SizedBox(width: 10),
              HMetric(
                label: 'BLDG RISK',
                value: bldRisk.toStringAsFixed(2),
                color: bldRisk < 0.3
                    ? C.teal
                    : bldRisk < 0.6
                    ? C.amber
                    : C.red,
              ),
            ],
          ),

          if (riskBuildings.isNotEmpty) ...[
            Divider(height: 18, color: C.gBdr),
            Text(
              'HIGH RISK BUILDINGS',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                letterSpacing: 2,
                color: C.red,
              ),
            ),
            const SizedBox(height: 8),
            ...riskBuildings.map(
              (b) => AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: C.red.withOpacity(.04),
                    border: Border.all(
                      color: C.red.withOpacity(.12 + glowCtrl.value * .06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.business_rounded, color: C.red, size: 13),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b.name,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: C.white,
                          ),
                        ),
                      ),
                      Text(
                        'RISK ${b.riskLevel.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          if (congRoads.isNotEmpty) ...[
            Divider(height: 18, color: C.gBdr),
            Text(
              'CONGESTED ROADS',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                letterSpacing: 2,
                color: C.amber,
              ),
            ),
            const SizedBox(height: 8),
            ...congRoads.map(
              (r) => Container(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: C.amber.withOpacity(.04),
                  border: Border.all(color: C.amber.withOpacity(.18)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.traffic_rounded, color: C.amber, size: 13),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: C.white,
                        ),
                      ),
                    ),
                    Text(
                      '${(r.congestionLevel * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: C.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
