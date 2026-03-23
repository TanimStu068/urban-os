import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/widgets/report_generator/data_kpi.dart';

typedef C = AppColors;

class DataSummaryWidget extends StatelessWidget {
  final LogProvider logProvider;
  final Animation<double> glowAnimation;

  const DataSummaryWidget({
    super.key,
    required this.logProvider,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final activeAlerts = logProvider.alerts.where((a) => a.isActive).length;
    final errEvents = logProvider.events
        .where((e) => e.level == EventLogLevel.error)
        .length;

    // Demo counts if empty
    final alertTotal = logProvider.alerts.isNotEmpty
        ? logProvider.alerts.length
        : 48;
    final eventTotal = logProvider.events.isNotEmpty
        ? logProvider.events.length
        : 312;
    final sysTotal = logProvider.systemLogs.isNotEmpty
        ? logProvider.systemLogs.length
        : 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (_, __) => Container(
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
                'AVAILABLE DATA',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.mutedLt,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  DataKpi(
                    '$alertTotal',
                    'ALERTS',
                    C.red,
                    activeAlerts > 0 ? '$activeAlerts active' : null,
                  ),
                  const SizedBox(width: 8),
                  DataKpi(
                    '$eventTotal',
                    'EVENTS',
                    C.cyan,
                    errEvents > 0 ? '$errEvents errors' : null,
                  ),
                  const SizedBox(width: 8),
                  DataKpi('$sysTotal', 'SYS LOGS', C.violet, null),
                  const SizedBox(width: 8),
                  DataKpi(
                    '${alertTotal + eventTotal + sysTotal}',
                    'TOTAL',
                    C.green,
                    null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
