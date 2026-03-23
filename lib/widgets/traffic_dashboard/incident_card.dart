import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/parking_analytics/tag_chip.dart';
import 'package:urban_os/widgets/road_detail/severity_badge.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class IncidentCard extends StatelessWidget {
  final TrafficIncident incident;
  final AnimationController glowCtrl, blinkCtrl;
  final VoidCallback onResolve;
  const IncidentCard({
    super.key,
    required this.incident,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext ctx) => AnimatedBuilder(
    animation: Listenable.merge([glowCtrl, blinkCtrl]),
    builder: (_, __) {
      final col = incident.isActive ? incident.color : C.muted;
      final isHigh = incident.severity == 'HIGH' && incident.isActive;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(.9),
          border: Border.all(
            color: isHigh
                ? col.withOpacity(.3 + blinkCtrl.value * .15)
                : col.withOpacity(.18 + glowCtrl.value * .05),
          ),
          boxShadow: incident.isActive
              ? [BoxShadow(color: col.withOpacity(.06), blurRadius: 14)]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withOpacity(incident.isActive ? .12 : .06),
                    border: Border.all(
                      color: col.withOpacity(incident.isActive ? .35 : .15),
                    ),
                  ),
                  child: Icon(
                    incident.icon,
                    color: col.withOpacity(incident.isActive ? 1 : .4),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TagChip(incident.type, col),
                          const SizedBox(width: 6),
                          SeverityBadge(
                            incident.severity,
                            incident.isActive,
                            blinkCtrl.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        incident.road,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: incident.isActive ? C.white : C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      incident.time,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        color: C.mutedLt,
                      ),
                    ),
                    if (!incident.isActive)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: C.green.withOpacity(.1),
                          border: Border.all(color: C.green.withOpacity(.3)),
                        ),
                        child: const Text(
                          'RESOLVED',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: C.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: col.withOpacity(.04),
                border: Border.all(color: col.withOpacity(.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: C.mutedLt, size: 12),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      incident.description,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: C.mutedLt,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (incident.isActive) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onResolve,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: C.green.withOpacity(.1),
                          border: Border.all(color: C.green.withOpacity(.35)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_rounded, color: C.green, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'MARK RESOLVED',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8.5,
                                color: C.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kAccent.withOpacity(.08),
                        border: Border.all(color: kAccent.withOpacity(.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.alt_route_rounded,
                            color: kAccent,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'REROUTE',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              color: kAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    },
  );
}
