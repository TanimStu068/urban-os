import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/notification_data_model.dart';
import 'package:urban_os/widgets/notification/notification_item.dart';

class NotifCard extends StatelessWidget {
  final NotificationItem notif;
  final bool isRead;
  final VoidCallback onTap;

  const NotifCard({
    super.key,
    required this.notif,
    required this.isRead,
    required this.onTap,
  });

  Color get _severityColor {
    switch (notif.severity) {
      case NotifSeverity.critical:
        return const Color(0xFFFF3B5C);
      case NotifSeverity.warning:
        return const Color(0xFFFFAA00);
      case NotifSeverity.info:
        return const Color(0xFF00D4FF);
    }
  }

  String get _severityLabel {
    switch (notif.severity) {
      case NotifSeverity.critical:
        return 'CRITICAL';
      case NotifSeverity.warning:
        return 'WARNING';
      case NotifSeverity.info:
        return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.white.withOpacity(0.03)
              : _severityColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? Colors.white.withOpacity(0.07)
                : _severityColor.withOpacity(0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _severityColor.withOpacity(0.3)),
              ),
              child: Icon(notif.icon, color: _severityColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _severityLabel,
                          style: TextStyle(
                            color: _severityColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notif.category,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _severityColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _severityColor.withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notif.title,
                    style: TextStyle(
                      color: isRead
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.body,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.white.withOpacity(0.25),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notif.district,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        notif.time,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
