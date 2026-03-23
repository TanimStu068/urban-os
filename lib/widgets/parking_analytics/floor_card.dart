import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/card_widget.dart';
import 'package:urban_os/widgets/parking_analytics/floor_row.dart';

class FloorCard extends StatelessWidget {
  final ParkingLot lot;
  final AnimationController glowCtrl;

  const FloorCard({Key? key, required this.lot, required this.glowCtrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'FLOOR BREAKDOWN',
      sub: '${lot.floors.length} levels  ·  per-floor occupancy',
      icon: Icons.layers_rounded,
      child: AnimatedBuilder(
        animation: glowCtrl,
        builder: (_, __) => Column(
          children: lot.floors
              .map((f) => FloorRow(floor: f, glowT: glowCtrl.value))
              .toList(),
        ),
      ),
    );
  }
}
