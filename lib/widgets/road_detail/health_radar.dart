import 'package:flutter/material.dart';

import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'package:urban_os/widgets/road_detail/radar_painter.dart';

class HealthRadarCard extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController radarCtrl;
  final AnimationController glowCtrl;

  const HealthRadarCard({
    Key? key,
    required this.road,
    required this.radarCtrl,
    required this.glowCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'ROAD HEALTH RADAR',
      sub: 'Multi-metric performance evaluation',
      icon: Icons.radar_rounded,
      child: SizedBox(
        height: 220,
        child: AnimatedBuilder(
          animation: Listenable.merge([radarCtrl, glowCtrl]),
          builder: (_, __) => CustomPaint(
            painter: RadarPainter(
              road: road,
              t: radarCtrl.value,
              glowT: glowCtrl.value,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}
