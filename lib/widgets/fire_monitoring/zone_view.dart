import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/fire_monitoring_data_model.dart';
import 'package:urban_os/widgets/fire_monitoring/zone_card.dart';

typedef ZoneToggleCallback = void Function(String zoneId);

class ZoneView extends StatelessWidget {
  final ScrollController scrollCtrl;
  final List<FireZone> filteredZones;
  final Set<String> expandedZones;
  final ZoneToggleCallback onToggleExpanded;
  final AnimationController glowCtrl;

  const ZoneView({
    Key? key,
    required this.scrollCtrl,
    required this.filteredZones,
    required this.expandedZones,
    required this.onToggleExpanded,
    required this.glowCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: filteredZones
            .map(
              (zone) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ZoneCard(
                  zone: zone,
                  isExpanded: expandedZones.contains(zone.id),
                  onTap: () => onToggleExpanded(zone.id),
                  glowCtrl: glowCtrl,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
