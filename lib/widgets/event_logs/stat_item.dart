import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_log_data_model.dart';

typedef C = AppColors;

/// Individual stat item widget
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatItem(this.label, this.value, this.color, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Events statistics bar widget
class EventsStatsBar extends StatelessWidget {
  final EventStatistics stats;

  const EventsStatsBar({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.sky.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem('TODAY', '${stats.eventsToday}', C.teal),
          StatItem('ERRORS', '${stats.errorCount}', C.orange),
          StatItem(
            'AVG TIME',
            '${stats.avgExecutionTime.toStringAsFixed(0)}ms',
            C.lime,
          ),
          StatItem('TOTAL', '${stats.totalEvents}', C.cyan),
        ],
      ),
    );
  }
}
