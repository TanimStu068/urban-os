import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';

typedef C = AppColors;

class EmptyState extends StatelessWidget {
  final RulePriority? filter;
  final String query;
  const EmptyState({super.key, required this.filter, required this.query});
  @override
  Widget build(BuildContext context) {
    final filterLabel = filter != null
        ? mapAlertSeverity(filter!, true).label
        : null;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.green.withOpacity(.08),
              border: Border.all(color: C.green.withOpacity(.3)),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: C.green,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ALL CLEAR',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              color: C.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            query.isNotEmpty
                ? 'No alerts match "$query"'
                : filter != null
                ? 'No $filterLabel alerts active'
                : 'No active alerts at this time',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: C.muted,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }
}
