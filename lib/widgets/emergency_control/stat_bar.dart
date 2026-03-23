import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';
import 'package:urban_os/widgets/emergency_control/stat_item.dart';

typedef C = AppColors;

class StatsBar extends StatelessWidget {
  final int activeIncidents;
  final int teamsDeployed;
  final int totalAffected;
  final List<EmergencyAlert> alerts;

  const StatsBar({
    Key? key,
    required this.activeIncidents,
    required this.teamsDeployed,
    required this.totalAffected,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final evacuationCount = alerts.where((a) => a.requiresEvacuation).length;

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
          StatItem('ACTIVE', '$activeIncidents', C.red),
          StatItem('DEPLOYED', '$teamsDeployed', C.orange),
          StatItem('AFFECTED', '$totalAffected', C.yellow),
          StatItem('EVACUATION', '$evacuationCount', C.pink),
        ],
      ),
    );
  }
}
