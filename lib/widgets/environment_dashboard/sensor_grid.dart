import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/sec_title.dart';
import 'package:urban_os/widgets/environment_dashboard/sensor_card.dart';

class SensorGrid extends StatelessWidget {
  final List<EnvSensorReading> sensors;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const SensorGrid({
    super.key,
    required this.sensors,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SecTitle('LIVE SENSORS', AppColors.teal),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 1.4,
          ),
          itemCount: sensors.length,
          itemBuilder: (_, i) => AnimatedBuilder(
            animation: Listenable.merge([glowCtrl, blinkCtrl]),
            builder: (_, __) => SensorCard(
              sensor: sensors[i],
              glowT: glowCtrl.value,
              blinkT: blinkCtrl.value,
            ),
          ),
        ),
      ],
    );
  }
}
