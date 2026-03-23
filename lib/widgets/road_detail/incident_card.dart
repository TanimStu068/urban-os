import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'incident_tile.dart';
import 'empty_state.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class IncidentsCard extends StatelessWidget {
  final RoadDetailData road;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const IncidentsCard({
    Key? key,
    required this.road,
    required this.glowCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'ACTIVE INCIDENTS',
      sub: '${road.activeIncidents.length} incident(s) on this road',
      icon: Icons.warning_amber_rounded,
      child: road.activeIncidents.isEmpty
          ? const EmptyState(
              'No active incidents',
              Icons.check_circle_outline_rounded,
              C.green,
            )
          : Column(
              children: road.activeIncidents
                  .map(
                    (inc) => AnimatedBuilder(
                      animation: Listenable.merge([glowCtrl, blinkCtrl]),
                      builder: (_, __) => IncidentTile(
                        incident: inc,
                        glowT: glowCtrl.value,
                        blinkT: blinkCtrl.value,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
