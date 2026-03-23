import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/severity_chip.dart';
import 'package:urban_os/widgets/accident_monitoring/small_badge.dart';

typedef C = AppColors;

class IncidentListTile extends StatelessWidget {
  final AccidentEvent accident;
  final bool isSelected;
  final double glowT, blinkT;
  final VoidCallback onTap;

  const IncidentListTile({
    super.key,
    required this.accident,
    required this.isSelected,
    required this.glowT,
    required this.blinkT,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    final acc = accident;
    final col = acc.severity.color;
    final isPulse =
        acc.severity == AccidentSeverity.critical ||
        acc.severity == AccidentSeverity.high;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? col.withOpacity(0.07)
              : C.bgCard.withOpacity(0.85),
          border: Border.all(
            color: isSelected
                ? col.withOpacity(0.4 + glowT * 0.1)
                : isPulse
                ? col.withOpacity(0.2 + blinkT * 0.1)
                : C.gBdr,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: col.withOpacity(0.07), blurRadius: 12)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withOpacity(0.12),
                    border: Border.all(
                      color: col.withOpacity(
                        isPulse ? 0.4 + blinkT * 0.2 : 0.3,
                      ),
                    ),
                    boxShadow: isPulse
                        ? [
                            BoxShadow(
                              color: col.withOpacity(0.2 * blinkT),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(acc.severity.icon, color: col, size: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acc.id,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? col : kAccent,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        acc.time,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                SeverityChip(acc.severity, blinkT, compact: true),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              acc.road,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: C.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              acc.location,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: C.muted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SmallBadge('${acc.vehiclesInvolved}V', col),
                const SizedBox(width: 4),
                if (acc.injuriesReported > 0) ...[
                  SmallBadge('${acc.injuriesReported}INJ', C.red),
                  const SizedBox(width: 4),
                ],
                SmallBadge(acc.responseStatus.label, acc.responseStatus.color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
