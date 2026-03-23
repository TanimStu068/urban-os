import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/alert_history_data_model.dart';
import 'package:urban_os/widgets/alert_history/alert_card.dart';

typedef C = AppColors;

class AlertsListWidget extends StatelessWidget {
  final List<AlertLog> filteredAlerts;
  final ScrollController scrollController;
  final Set<AlertLog> expandedAlerts;
  final void Function(String alertId) onToggleExpanded;
  // final void Function(AlertLog alert, bool status) onStatusChange;
  final void Function(AlertLog alert, AlertStatus status)
  onStatusChange; // ✅ fix

  const AlertsListWidget({
    super.key,
    required this.filteredAlerts,
    required this.scrollController,
    required this.expandedAlerts,
    required this.onToggleExpanded,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          if (filteredAlerts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, color: C.muted, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No alerts match your filters',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(filteredAlerts.length, (i) {
              final alert = filteredAlerts[i];
              final isExpanded = expandedAlerts.contains(alert);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AlertCard(
                  alert: alert,
                  isExpanded: isExpanded,
                  onTap: () => onToggleExpanded(alert.id),
                  onStatusChange: (alert, status) =>
                      onStatusChange(alert, status),
                ),
              );
            }),
        ],
      ),
    );
  }
}
