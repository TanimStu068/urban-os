import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/fire_monitoring/stat_item.dart';

typedef C = AppColors;

class ZoneStatsBar extends StatelessWidget {
  final int fireZones;
  final int peopleAtRisk;
  final int equipmentActive;
  final double avgTemp;

  const ZoneStatsBar({
    Key? key,
    required this.fireZones,
    required this.peopleAtRisk,
    required this.equipmentActive,
    required this.avgTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.red.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem('FIRE ZONES', '$fireZones', C.red),
          StatItem('AT RISK', '$peopleAtRisk', C.yellow),
          StatItem('EQUIPMENT', '$equipmentActive', C.cyan),
          StatItem('TEMP AVG', '${avgTemp.toStringAsFixed(0)}°', C.orange),
        ],
      ),
    );
  }
}
