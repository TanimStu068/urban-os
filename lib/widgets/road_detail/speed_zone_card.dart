import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'speed_zone_map_painter.dart';
import 'speed_zone_row.dart';

class SpeedZonesCard extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController glowCtrl;

  const SpeedZonesCard({Key? key, required this.road, required this.glowCtrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'SPEED ZONES',
      sub: 'Current vs limit across ${road.speedZones.length} zones',
      icon: Icons.speed_rounded,
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: SpeedZoneMapPainter(
                  zones: road.speedZones,
                  totalKm: road.length / 1000,
                  glowT: glowCtrl.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...road.speedZones.map(
            (z) => AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => SpeedZoneRow(zone: z, glowT: glowCtrl.value),
            ),
          ),
        ],
      ),
    );
  }
}
