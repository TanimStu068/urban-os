import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class EventStatsBar extends StatelessWidget {
  final int activeCount;
  final int totalCount;
  final int templateCount;
  final int systemsCount;

  const EventStatsBar({
    super.key,
    required this.activeCount,
    required this.totalCount,
    required this.templateCount,
    required this.systemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.cyan.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem('ACTIVE', '$activeCount', C.red),
          _StatItem('TOTAL', '$totalCount', C.cyan),
          _StatItem('TEMPLATES', '$templateCount', C.teal),
          _StatItem('SYSTEMS', '$systemsCount', C.yellow),
        ],
      ),
    );
  }
}

/// _StatItem widget (can remain private if used only inside EventStatsBar)
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}
