import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/alert_history_data_model.dart';
import 'package:urban_os/widgets/alert_history/alert_detail.dart';

typedef C = AppColors;

class AlertCard extends StatelessWidget {
  final AlertLog alert;
  final bool isExpanded;
  final VoidCallback onTap;
  // final Function(AlertStatus) onStatusChange;
  final void Function(AlertLog alert, AlertStatus status)
  onStatusChange; // ✅ fix

  const AlertCard({
    super.key,
    required this.alert,
    required this.isExpanded,
    required this.onTap,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: C.bgCard.withOpacity(0.8),
          border: Border.all(
            color: alert.severity.color.withOpacity(isExpanded ? 0.4 : 0.15),
          ),
          boxShadow: [
            if (isExpanded)
              BoxShadow(
                color: alert.severity.color.withOpacity(0.2),
                blurRadius: 12,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  alert.severity.icon,
                  color: alert.severity.color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        alert.timeAgo,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6.5,
                          color: C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: alert.severity.color.withOpacity(0.15),
                    border: Border.all(
                      color: alert.severity.color.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    alert.severity.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6,
                      color: alert.severity.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            // Status indicator
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: alert.isActive ? C.red : C.green,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  alert.status.name.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: alert.isActive ? C.red : C.green,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: alert.type.color.withOpacity(0.12),
                    border: Border.all(
                      color: alert.type.color.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(alert.type.icon, color: alert.type.color, size: 8),
                      const SizedBox(width: 3),
                      Text(
                        alert.type.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          color: alert.type.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Expanded content
            if (isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(color: Color(0x1A00FFCC), height: 1),
              const SizedBox(height: 10),
              AlertDetail('SOURCE', alert.sourceName),
              AlertDetail('ID', alert.id),
              AlertDetail('AFFECTED SYSTEMS', '${alert.affectedSystems}'),
              const SizedBox(height: 8),
              Text(
                'DESCRIPTION',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: C.mutedLt,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                alert.description,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.white,
                  height: 1.4,
                ),
              ),
              if (alert.actionTaken != null) ...[
                const SizedBox(height: 8),
                Text(
                  'ACTION TAKEN',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.actionTaken!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    color: C.green,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              // Action buttons
              Row(
                children: [
                  if (alert.isActive) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            onStatusChange(alert, AlertStatus.acknowledged),

                        // onTap: () => onStatusChange(AlertStatus.acknowledged),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: C.amber.withOpacity(0.12),
                            border: Border.all(color: C.amber.withOpacity(0.3)),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: C.amber,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'ACK',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    color: C.amber,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            onStatusChange(alert, AlertStatus.resolved),

                        // onTap: () => onStatusChange(AlertStatus.resolved),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: C.green.withOpacity(0.12),
                            border: Border.all(color: C.green.withOpacity(0.3)),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt_rounded,
                                  color: C.green,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'RESOLVE',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    color: C.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            onStatusChange(alert, AlertStatus.dismissed),

                        // onTap: () => onStatusChange(AlertStatus.dismissed),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: C.red.withOpacity(0.12),
                            border: Border.all(color: C.red.withOpacity(0.3)),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close_rounded,
                                  color: C.red,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'DISMISS',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    color: C.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
