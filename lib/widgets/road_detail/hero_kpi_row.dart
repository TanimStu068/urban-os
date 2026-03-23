import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/kpi_tile.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class HeroKpiRow extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController glowCtrl;

  const HeroKpiRow({super.key, required this.road, required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Row(
        children: [
          KpiTile(
            'CONGESTION',
            '${road.congestion}%',
            road.color,
            Icons.traffic_rounded,
            glowCtrl.value,
          ),
          const SizedBox(width: 8),
          KpiTile(
            'AVG SPEED',
            '${road.speed} km/h',
            C.amber,
            Icons.speed_rounded,
            glowCtrl.value,
          ),
          const SizedBox(width: 8),
          KpiTile(
            'VOLUME',
            '${road.vehicles}/h',
            kAccent,
            Icons.directions_car_rounded,
            glowCtrl.value,
          ),
          const SizedBox(width: 8),
          KpiTile(
            'RELIABILITY',
            '${(road.reliability * 100).toStringAsFixed(0)}%',
            C.teal,
            Icons.verified_rounded,
            glowCtrl.value,
          ),
        ],
      ),
    );
  }
}
