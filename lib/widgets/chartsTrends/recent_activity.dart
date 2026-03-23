import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/providers/log/log_provider.dart';

typedef C = AppColors;

class RecentActivityWidget extends StatelessWidget {
  final LogProvider logProvider;

  const RecentActivityWidget({super.key, required this.logProvider});

  @override
  Widget build(BuildContext context) {
    final items = <(DateTime, String, Color, IconData)>[];

    // Add recent alerts
    for (final a in logProvider.alerts.take(4)) {
      items.add((
        a.timestamp,
        'ALERT: ${a.title}',
        C.red,
        Icons.warning_amber_rounded,
      ));
    }

    // Add recent events
    for (final e in logProvider.events.take(4)) {
      final col = e.level == EventLogLevel.error
          ? C.red
          : e.level == EventLogLevel.warning
          ? C.amber
          : C.cyan;
      items.add((e.timestamp, 'EVENT: ${e.message}', col, Icons.bolt_rounded));
    }

    // Sort by timestamp descending
    items.sort((a, b) => b.$1.compareTo(a.$1));

    // Demo fallback
    if (items.isEmpty) {
      final now = DateTime.now();
      items.addAll([
        (
          now.subtract(const Duration(minutes: 2)),
          'ALERT: High temperature sensor D7',
          C.red,
          Icons.warning_amber_rounded,
        ),
        (
          now.subtract(const Duration(minutes: 8)),
          'EVENT: Rule triggered: HVAC auto-cool',
          C.cyan,
          Icons.bolt_rounded,
        ),
        (
          now.subtract(const Duration(minutes: 15)),
          'EVENT: Actuator valve opened',
          C.amber,
          Icons.settings_rounded,
        ),
        (
          now.subtract(const Duration(minutes: 31)),
          'ALERT: Low battery node B-12',
          C.amber,
          Icons.battery_0_bar_rounded,
        ),
        (
          now.subtract(const Duration(hours: 1, minutes: 4)),
          'EVENT: Anomaly resolved',
          C.green,
          Icons.check_circle_outline_rounded,
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RECENT ACTIVITY',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.mutedLt,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            ...items.take(6).map((item) {
              final ago = DateTime.now().difference(item.$1);
              final agoStr = ago.inMinutes < 60
                  ? '${ago.inMinutes}m ago'
                  : ago.inHours < 24
                  ? '${ago.inHours}h ago'
                  : '${ago.inDays}d ago';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: item.$3.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: item.$3.withOpacity(0.3)),
                      ),
                      child: Icon(item.$4, color: item.$3, size: 11),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.$2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          color: C.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      agoStr,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7.5,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
