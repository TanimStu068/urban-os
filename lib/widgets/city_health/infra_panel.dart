import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/infrastructure/building_model.dart';
import 'package:urban_os/models/infrastructure/road_model.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';
import 'package:urban_os/widgets/city_health/infra_count.dart';
import 'package:urban_os/widgets/city_health/infra_metrict.dart';

typedef C = AppColors;

class InfraPanel extends StatelessWidget {
  final double infraHealth, congestion, bldRisk;
  final List<BuildingModel> buildings;
  final List<RoadModel> roads;
  const InfraPanel({
    super.key,
    required this.infraHealth,
    required this.congestion,
    required this.bldRisk,
    required this.buildings,
    required this.roads,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'INFRASTRUCTURE',
            icon: Icons.business_rounded,
            color: C.violet,
          ),
          Row(
            children: [
              Expanded(
                child: InfraMetric(
                  label: 'HEALTH INDEX',
                  value: '${infraHealth.toStringAsFixed(1)}%',
                  color: infraHealth >= 80
                      ? C.teal
                      : infraHealth >= 60
                      ? C.amber
                      : C.red,
                  icon: Icons.health_and_safety_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InfraMetric(
                  label: 'ROAD CONGESTION',
                  value: '${congestion.toStringAsFixed(1)}%',
                  color: congestion < 50
                      ? C.teal
                      : congestion < 75
                      ? C.amber
                      : C.red,
                  icon: Icons.traffic_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InfraMetric(
                  label: 'BUILDING RISK',
                  value: '${bldRisk.toStringAsFixed(1)}',
                  color: bldRisk < 0.3
                      ? C.teal
                      : bldRisk < 0.6
                      ? C.amber
                      : C.red,
                  icon: Icons.business_rounded,
                ),
              ),
            ],
          ),
          Divider(height: 20, color: C.gBdr),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfraCount(
                icon: Icons.apartment_rounded,
                label: 'BUILDINGS',
                count: buildings.length,
                color: C.cyan,
              ),
              InfraCount(
                icon: Icons.route_rounded,
                label: 'ROADS',
                count: roads.length,
                color: C.teal,
              ),
              InfraCount(
                icon: Icons.bolt_rounded,
                label: 'HIGH RISK BLDGS',
                count: buildings.where((b) => b.riskLevel > 0.7).length,
                color: C.red,
              ),
              InfraCount(
                icon: Icons.traffic_rounded,
                label: 'CONGESTED',
                count: roads.where((r) => r.congestionLevel > 0.75).length,
                color: C.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
