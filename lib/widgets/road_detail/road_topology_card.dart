import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'package:urban_os/widgets/road_detail/live_dot.dart';
import 'road_topology_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class RoadTopologyCard extends StatelessWidget {
  final RoadDetailData road;
  final List<LiveDot> liveDots;
  final AnimationController vehicleCtrl;
  final AnimationController pulseCtrl;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const RoadTopologyCard({
    super.key,
    required this.road,
    required this.liveDots,
    required this.vehicleCtrl,
    required this.pulseCtrl,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'ROAD TOPOLOGY',
      sub:
          '${road.lanes} lanes  ·  ${(road.length / 1000).toStringAsFixed(1)} km  ·  Live vehicle tracking',
      icon: Icons.route_rounded,
      child: SizedBox(
        height: 200,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            vehicleCtrl,
            pulseCtrl,
            glowCtrl,
            blinkCtrl,
          ]),
          builder: (_, __) => CustomPaint(
            painter: RoadTopologyPainter(
              road: road,
              dots: liveDots,
              pulseT: pulseCtrl.value,
              glowT: glowCtrl.value,
              blinkT: blinkCtrl.value,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}
