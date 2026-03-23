import 'package:flutter/material.dart';
import 'package:urban_os/widgets/city_dashboard/kpi_card.dart';

class KpiRow extends StatelessWidget {
  final double energy, traffic, aqi, water;
  final AnimationController glowCtrl;
  const KpiRow({
    super.key,
    required this.energy,
    required this.traffic,
    required this.aqi,
    required this.water,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: KpiCard(
              label: 'ENERGY',
              value: '${energy.toStringAsFixed(1)}%',
              icon: Icons.bolt_rounded,
              color: C.amber,
              sub: 'Grid Load',
              progress: energy / 100,
              glowCtrl: glowCtrl,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: KpiCard(
              label: 'TRAFFIC',
              value: '${traffic.toStringAsFixed(1)}%',
              icon: Icons.directions_car_rounded,
              color: C.cyan,
              sub: 'Flow Rate',
              progress: traffic / 100,
              glowCtrl: glowCtrl,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: KpiCard(
              label: 'AQI',
              value: aqi.toStringAsFixed(0),
              icon: Icons.air_rounded,
              color: aqi < 100
                  ? C.green
                  : aqi < 150
                  ? C.amber
                  : C.red,
              sub: aqi < 100
                  ? 'Good'
                  : aqi < 150
                  ? 'Moderate'
                  : 'Unhealthy',
              progress: (aqi / 300).clamp(0, 1),
              glowCtrl: glowCtrl,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: KpiCard(
              label: 'WATER',
              value: '${water.toStringAsFixed(1)}%',
              icon: Icons.water_drop_rounded,
              color: C.teal,
              sub: 'Flow Rate',
              progress: water / 100,
              glowCtrl: glowCtrl,
            ),
          ),
        ],
      ),
    );
  }
}
