import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/severity_badge.dart';
import 'package:urban_os/widgets/road_detail/tag_chip.dart';

typedef C = AppColors;

class IncidentTile extends StatelessWidget {
  final Incident incident;
  final double glowT, blinkT;
  const IncidentTile({
    super.key,
    required this.incident,
    required this.glowT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: incident.color.withOpacity(0.05),
      border: Border.all(
        color: incident.color.withOpacity(0.25 + blinkT * 0.15),
      ),
      boxShadow: [
        BoxShadow(color: incident.color.withOpacity(0.06), blurRadius: 12),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: incident.color.withOpacity(0.12),
            border: Border.all(color: incident.color.withOpacity(0.4)),
          ),
          child: Icon(incident.icon, color: incident.color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TagChip(incident.type, incident.color),
                  const SizedBox(width: 6),
                  SeverityBadge(incident.severity, true, blinkT),
                  const SizedBox(width: 6),
                  Text(
                    'KM ${(incident.position * 7.8).toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.mutedLt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                incident.description,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8.5,
                  color: C.mutedLt,
                  height: 1.4,
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
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: C.amber.withOpacity(0.1),
                border: Border.all(color: C.amber.withOpacity(0.3)),
              ),
              child: const Text(
                'RESPOND',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.amber,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
