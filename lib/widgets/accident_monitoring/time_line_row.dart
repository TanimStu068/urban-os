import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/tag_chip.dart';

class TimelineRow extends StatelessWidget {
  final TimelineEntry entry;
  final bool isLast;
  final double glowT;
  const TimelineRow({
    super.key,
    required this.entry,
    required this.isLast,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color.withOpacity(0.12),
              border: Border.all(color: entry.color.withOpacity(0.35)),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.color.withOpacity(0.8),
                ),
              ),
            ),
          ),
          if (!isLast)
            Container(
              width: 1.5,
              height: 28,
              color: entry.color.withOpacity(0.2),
            ),
        ],
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    entry.time,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: entry.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TagChip(entry.actor, entry.color),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                entry.event,
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
      ),
    ],
  );
}
