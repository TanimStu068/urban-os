import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/incident_card.dart';

typedef C = AppColors;

class IncidentsTab extends StatelessWidget {
  final List<TrafficIncident> incidents;
  final AnimationController glowCtrl, blinkCtrl;
  final ValueChanged<TrafficIncident> onResolve;
  const IncidentsTab({
    super.key,
    required this.incidents,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext ctx) => ListView(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
    physics: const BouncingScrollPhysics(),
    children: [
      // Active count summary
      AnimatedBuilder(
        animation: glowCtrl,
        builder: (_, __) => Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: C.bgCard.withOpacity(.88),
            border: Border.all(
              color: C.red.withOpacity(.2 + glowCtrl.value * .08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.red.withOpacity(.12),
                  border: Border.all(color: C.red.withOpacity(.4)),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: C.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${incidents.where((i) => i.isActive).length} ACTIVE INCIDENTS',
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: C.red,
                      ),
                    ),
                    Text(
                      '${incidents.where((i) => !i.isActive).length} resolved today',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: C.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'HIGH RISK ROADS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.muted,
                    ),
                  ),
                  const Text(
                    'Ring Rd 4 · N.Access',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ...incidents.map(
        (inc) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: IncidentCard(
            incident: inc,
            glowCtrl: glowCtrl,
            blinkCtrl: blinkCtrl,
            onResolve: () => onResolve(inc),
          ),
        ),
      ),
    ],
  );
}
