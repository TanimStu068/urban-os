import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/notification_data_model.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final NotifSeverity severity;
  final String district;
  final IconData icon;
  final String category;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.severity,
    required this.district,
    required this.icon,
    required this.category,
    required this.isRead,
  });
}
