import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/accident_monitoring/resources_row.dart';
import 'package:urban_os/widgets/accident_monitoring/response_progress_bar.dart';
import 'package:urban_os/widgets/accident_monitoring/unit_chip.dart';

typedef C = AppColors;

class ResponseTab extends StatelessWidget {
  final AccidentEvent accident;
  final double glowT;

  const ResponseTab({super.key, required this.accident, required this.glowT});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Dispatched Units ──
        CardWidget(
          title: 'DISPATCHED UNITS',
          sub:
              '${accident.dispatchedUnits.length} units assigned to ${accident.id}',
          icon: Icons.local_fire_department_rounded,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: accident.dispatchedUnits
                .map((u) => UnitChip(unit: u, glowT: glowT))
                .toList(),
          ),
        ),

        const SizedBox(height: 10),

        // ── Response Timeline ──
        CardWidget(
          title: 'RESPONSE TIMELINE',
          sub: 'Phase progression',
          icon: Icons.timer_rounded,
          child: ResponseProgressBar(
            status: accident.responseStatus,
            glowT: glowT,
          ),
        ),

        const SizedBox(height: 10),

        // ── Nearby Resources ──
        CardWidget(
          title: 'NEARBY RESOURCES',
          sub: 'Available units within 5 km',
          icon: Icons.location_on_rounded,
          child: Column(
            children: [
              ResourceRow('AMB-01', 'AMBULANCE', '1.2 km', C.red, glowT),
              ResourceRow('AMB-09', 'AMBULANCE', '3.4 km', C.red, glowT),
              ResourceRow('POL-20', 'POLICE', '0.8 km', C.cyan, glowT),
              ResourceRow('FIR-02', 'FIRE', '2.1 km', C.orange, glowT),
              ResourceRow('TOW-06', 'TOW TRUCK', '4.7 km', C.amber, glowT),
            ],
          ),
        ),
      ],
    );
  }
}
