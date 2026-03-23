import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/parking_analytics/cap_chip.dart';

class InfoCard extends StatelessWidget {
  final ParkingLot lot;

  const InfoCard({Key? key, required this.lot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'FACILITIES',
      sub: 'Hardware & infrastructure',
      icon: Icons.memory_rounded,
      child: Row(
        children: [
          CapChip('EV CHARGING', Icons.ev_station_rounded, lot.hasEV),
          const SizedBox(width: 6),
          CapChip('CCTV', Icons.videocam_rounded, lot.hasCCTV),
          const SizedBox(width: 6),
          CapChip('BARRIER', Icons.fence_rounded, lot.hasBarrier),
          const SizedBox(width: 6),
          CapChip('ROOFTOP', Icons.roofing_rounded, lot.hasRooftop),
        ],
      ),
    );
  }
}
