import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/status_dot.dart';

class ZoneCard extends StatelessWidget {
  final PowerZone zone;
  final bool isSelected;
  final double glowT, blinkT;
  final VoidCallback onTap;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.isSelected,
    required this.glowT,
    required this.blinkT,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = zone.status.color;
    final isAlert =
        zone.status == ZoneStatus.critical || zone.status == ZoneStatus.warning;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? col.withOpacity(0.1)
              : zone.status == ZoneStatus.critical
              ? C.red.withOpacity(0.05 + blinkT * 0.03)
              : C.bgCard.withOpacity(0.85),
          border: Border.all(
            color: isSelected
                ? col.withOpacity(0.5)
                : isAlert
                ? col.withOpacity(0.2 + blinkT * 0.1)
                : C.gBdr,
            width: isSelected ? 1.3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: col.withOpacity(0.1 + glowT * 0.05),
                    blurRadius: 10,
                  ),
                ]
              : isAlert
              ? [
                  BoxShadow(
                    color: col.withOpacity(0.05 + blinkT * 0.03),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  zone.id,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: col.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                StatusDot(zone.status, blinkT),
              ],
            ),
            const Spacer(),
            Text(
              zone.name,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8.5,
                color: C.white,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Mini load bar
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: C.muted.withOpacity(0.3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (zone.loadPct / 100).clamp(0, 1),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: col,
                      boxShadow: [
                        BoxShadow(color: col.withOpacity(0.4), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              '${zone.loadPct.toStringAsFixed(0)}%  ·  ${(zone.consumption / 1000).toStringAsFixed(1)} MW',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: col.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
