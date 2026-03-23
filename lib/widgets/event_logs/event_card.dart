import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_log_data_model.dart';
import 'package:urban_os/widgets/event_logs/event_detail.dart';

typedef C = AppColors;

class EventCard extends StatelessWidget {
  final EventLog event;
  final bool isExpanded;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isExpanded,
    required this.onTap,
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
            color: event.type.color.withOpacity(isExpanded ? 0.4 : 0.15),
          ),
          boxShadow: [
            if (isExpanded)
              BoxShadow(
                color: event.type.color.withOpacity(0.2),
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
                Icon(event.type.icon, color: event.type.color, size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            event.formattedTime,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 6.5,
                              color: C.mutedLt,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.timeAgo,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 6.5,
                              color: C.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: event.success ? C.green : C.red,
                  ),
                ),
              ],
            ),
            // Severity & Type
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: event.severity.color.withOpacity(0.15),
                    border: Border.all(
                      color: event.severity.color.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        event.severity.icon,
                        color: event.severity.color,
                        size: 8,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        event.severity.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          color: event.severity.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: event.type.color.withOpacity(0.12),
                    border: Border.all(
                      color: event.type.color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    event.type.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6,
                      color: event.type.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (event.executionTime > 0)
                  Text(
                    '${event.executionTime}ms',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.lime,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            // Expanded details
            if (isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(color: Color(0x1A00FFCC), height: 1),
              const SizedBox(height: 10),
              EventDetail('Module', event.sourceModule),
              EventDetail('Category', event.category.name.toUpperCase()),
              if (event.userId != null) EventDetail('User', event.userId!),
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
                event.description,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.white,
                  height: 1.4,
                ),
              ),
              if (event.metadata != null) ...[
                const SizedBox(height: 8),
                Text(
                  'METADATA',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.cyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.bgCard2.withOpacity(0.5),
                    border: Border.all(color: C.cyan.withOpacity(0.2)),
                  ),
                  child: Text(
                    event.metadata!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.cyan,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
