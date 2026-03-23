import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'sensor_tile.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SensorsCard extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController pulseCtrl;

  const SensorsCard({
    Key? key,
    required this.road,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlineCount = road.sensors.where((s) => s.isOnline).length;

    return CardWidget(
      title: 'SENSOR NETWORK',
      sub: '$onlineCount/${road.sensors.length} sensors online',
      icon: Icons.sensors_rounded,
      child: AnimatedBuilder(
        animation: Listenable.merge([glowCtrl, blinkCtrl, pulseCtrl]),
        builder: (_, __) => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: road.sensors.length,
          itemBuilder: (_, i) => SensorTile(
            sensor: road.sensors[i],
            glowT: glowCtrl.value,
            blinkT: blinkCtrl.value,
            pulseT: pulseCtrl.value,
          ),
        ),
      ),
    );
  }
}
