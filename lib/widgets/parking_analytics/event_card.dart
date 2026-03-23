import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/parking_analytics/event_row.dart';

class EventsCard extends StatelessWidget {
  final ParkingLot lot;
  final AnimationController glowCtrl;

  const EventsCard({Key? key, required this.lot, required this.glowCtrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'RECENT EVENTS',
      sub: 'Live entry / exit log',
      icon: Icons.receipt_long_rounded,
      child: Column(
        children: lot.recentEvents
            .map(
              (e) => AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => EventRow(event: e, glowT: glowCtrl.value),
              ),
            )
            .toList(),
      ),
    );
  }
}
