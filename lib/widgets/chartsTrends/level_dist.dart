import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/providers/log/log_provider.dart';

typedef C = AppColors;

class EventLevelBreakdownWidget extends StatelessWidget {
  final LogProvider logProvider;

  const EventLevelBreakdownWidget({super.key, required this.logProvider});

  @override
  Widget build(BuildContext context) {
    // Count occurrences of each event level
    final counts = <EventLogLevel, int>{};
    for (final l in EventLogLevel.values) counts[l] = 0;
    for (final e in logProvider.events) {
      counts[e.level] = (counts[e.level] ?? 0) + 1;
    }

    // Demo fallback if all zero
    if (counts.values.every((v) => v == 0)) {
      counts[EventLogLevel.info] = 45;
      counts[EventLogLevel.warning] = 12;
      counts[EventLogLevel.error] = 4;
      counts[EventLogLevel.debug] = 28;
      counts[EventLogLevel.trace] = 9;
    }

    // Colors per level
    final levelColors = {
      EventLogLevel.info: C.cyan,
      EventLogLevel.warning: C.amber,
      EventLogLevel.error: C.red,
      EventLogLevel.debug: C.violet,
      EventLogLevel.trace: C.mutedLt,
    };

    final maxVal = counts.values.fold(0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
              'EVENT LEVEL BREAKDOWN',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.mutedLt,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            ...EventLogLevel.values.map((l) {
              final count = counts[l] ?? 0;
              final frac = maxVal == 0 ? 0.0 : count / maxVal;
              final col = levelColors[l] ?? C.mutedLt;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 54,
                      child: Text(
                        l.name.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: col,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: col.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            height: 14,
                            width: double.infinity * frac,
                            child: FractionallySizedBox(
                              widthFactor: frac,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: col.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border(
                                    right: BorderSide(
                                      color: col.withOpacity(0.6),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 10,
                          color: col,
                        ),
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
