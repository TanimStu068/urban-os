import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/card_widget.dart';
import 'package:urban_os/widgets/traffic_light_control/compact_approach_card.dart';

class ApproachGridCard extends StatelessWidget {
  final Intersection ix;
  final AnimationController glowCtrl;

  const ApproachGridCard({super.key, required this.ix, required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    final totalVehicles = ix.approaches.fold(
      0,
      (s, a) => s + a.waitingVehicles,
    );

    return CardWidget(
      title: 'APPROACH QUEUES',
      sub: '$totalVehicles vehicles · 4 approaches',
      icon: Icons.queue_rounded,
      child: AnimatedBuilder(
        animation: glowCtrl,
        builder: (_, __) {
          final lanes = ix.approaches;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CompactApproachCard(
                      lane: lanes[0],
                      glowT: glowCtrl.value,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: CompactApproachCard(
                      lane: lanes[1],
                      glowT: glowCtrl.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: CompactApproachCard(
                      lane: lanes[2],
                      glowT: glowCtrl.value,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: CompactApproachCard(
                      lane: lanes[3],
                      glowT: glowCtrl.value,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
