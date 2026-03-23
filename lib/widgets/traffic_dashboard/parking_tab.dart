import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/parking_card.dart';
import 'package:urban_os/widgets/traffic_dashboard/parking_donut_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/section_card.dart';

class ParkingTab extends StatelessWidget {
  final List<ParkingZone> zones;
  final AnimationController glowCtrl, pulseCtrl;
  const ParkingTab({
    super.key,
    required this.zones,
    required this.glowCtrl,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext ctx) => ListView(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
    physics: const BouncingScrollPhysics(),
    children: [
      // Donut summary
      SectionCard(
        title: 'CITY PARKING OVERVIEW',
        sub: 'Aggregated occupancy',
        icon: Icons.local_parking_rounded,
        child: SizedBox(
          height: 170,
          child: AnimatedBuilder(
            animation: Listenable.merge([glowCtrl, pulseCtrl]),
            builder: (_, __) => CustomPaint(
              painter: ParkingDonutPainter(zones: zones, glowT: glowCtrl.value),
              size: Size.infinite,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      ...zones.map(
        (z) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedBuilder(
            animation: glowCtrl,
            builder: (_, __) => ParkingCard(zone: z, glowT: glowCtrl.value),
          ),
        ),
      ),
    ],
  );
}
