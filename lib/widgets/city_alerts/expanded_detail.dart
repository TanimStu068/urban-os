import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/widgets/city_alerts/action_button.dart';
import 'package:urban_os/widgets/city_alerts/detail_item.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';

typedef C = AppColors;

class ExpandedDetail extends StatelessWidget {
  final AlertLog alert;
  final Color color;
  final VoidCallback onAcknowledge, onDismiss;
  const ExpandedDetail({
    super.key,
    required this.alert,
    required this.color,
    required this.onAcknowledge,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: color.withOpacity(.15)),
          const SizedBox(height: 12),

          // Description
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color.withOpacity(.04),
              border: Border.all(color: color.withOpacity(.12)),
            ),
            child: Text(
              alert.description,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: C.mutedLt,
                letterSpacing: .3,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Detail grid
          Row(
            children: [
              Expanded(
                child: DetailItem(
                  label: 'ALERT ID',
                  value: alert.id,
                  icon: Icons.tag_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DetailItem(
                  label: 'RESOURCE',
                  value: alert.resourceId ?? 'N/A',
                  icon: Icons.location_city_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailItem(
                  label: 'TYPE',
                  value: alert.resourceType ?? 'Unknown',
                  icon: Icons.sensors_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DetailItem(
                  label: 'SEVERITY',
                  value: mapAlertSeverity(alert.severity, alert.isActive).label,
                  icon: mapAlertSeverity(alert.severity, alert.isActive).icon,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action buttons
          if (alert.isActive)
            Row(
              children: [
                Expanded(
                  child: ActionBtn(
                    label: 'ACKNOWLEDGE',
                    icon: Icons.done_all_rounded,
                    color: C.green,
                    onTap: onAcknowledge,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ActionBtn(
                    label: 'DISPATCH TEAM',
                    icon: Icons.send_rounded,
                    color: color,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: C.muted.withOpacity(.3)),
                      color: C.gBg,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: C.mutedLt,
                      size: 18,
                    ),
                  ),
                ),
              ],
            )
          else
            ActionBtn(
              label: 'DISMISS RESOLVED',
              icon: Icons.close_rounded,
              color: C.muted,
              onTap: onDismiss,
            ),
        ],
      ),
    );
  }
}
