import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/wind_compass_painter.dart';
import 'package:urban_os/widgets/environment_dashboard/wval.dart';

class WindCompassCard extends StatelessWidget {
  final double windDegree;
  final EnvSensorReading windSensor;
  final AnimationController glowCtrl;
  final AnimationController windCtrl;

  const WindCompassCard({
    super.key,
    required this.windDegree,
    required this.windSensor,
    required this.glowCtrl,
    required this.windCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'WIND',
      icon: Icons.air_rounded,
      color: AppColors.mint,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: Listenable.merge([glowCtrl, windCtrl]),
              builder: (_, __) => CustomPaint(
                painter: WindCompassPainter(
                  deg: windDegree,
                  speed: windSensor.value,
                  glow: glowCtrl.value,
                  animT: windCtrl.value,
                ),
                size: const Size(double.infinity, 120),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: WVal(
                  'SPEED',
                  windSensor.value.toStringAsFixed(1),
                  'km/h',
                  AppColors.mint,
                ),
              ),
              Expanded(
                child: WVal('DIR', _compassDir(windDegree), '', AppColors.teal),
              ),
              Expanded(
                child: WVal(
                  'GUST',
                  (windSensor.value * 1.35).toStringAsFixed(0),
                  'km/h',
                  AppColors.cyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _compassDir(double deg) {
    const dirs = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];
    return dirs[((deg + 11.25) / 22.5).floor() % 16];
  }
}
