import 'package:flutter/material.dart';
import 'package:urban_os/widgets/notification/notification_item.dart';

enum NotifSeverity { critical, warning, info }

final List<String> filters = ['All', 'Critical', 'Warning', 'Info', 'System'];

final List<NotificationItem> notifications = [
  NotificationItem(
    id: 'n1',
    title: 'Critical AQI Threshold Exceeded',
    body:
        'Industrial District — AQI reached 187. Air filtration units activated automatically.',
    time: '2 min ago',
    severity: NotifSeverity.critical,
    district: 'Industrial District',
    icon: Icons.air_rounded,
    category: 'Environment',
    isRead: false,
  ),
  NotificationItem(
    id: 'n2',
    title: 'Fire Alarm Triggered',
    body:
        'Building 42-C, Medical District. Emergency services dispatched. Zone sealed.',
    time: '8 min ago',
    severity: NotifSeverity.critical,
    district: 'Medical District',
    icon: Icons.local_fire_department_rounded,
    category: 'Safety',
    isRead: false,
  ),
  NotificationItem(
    id: 'n3',
    title: 'Grid Overload — Sector 7',
    body:
        'Power consumption at 94% capacity. Rerouting through backup grid. Non-critical zones dimmed.',
    time: '15 min ago',
    severity: NotifSeverity.warning,
    district: 'Commercial District',
    icon: Icons.bolt_rounded,
    category: 'Energy',
    isRead: false,
  ),
  NotificationItem(
    id: 'n4',
    title: 'Traffic Congestion — North Corridor',
    body:
        'Vehicle density 340% above baseline on Main Blvd. Signal timings auto-adjusted.',
    time: '22 min ago',
    severity: NotifSeverity.warning,
    district: 'Transport Hub',
    icon: Icons.traffic_rounded,
    category: 'Traffic',
    isRead: true,
  ),
  NotificationItem(
    id: 'n5',
    title: 'Automation Rule Triggered',
    body:
        'Rule #A-047 "Rain Speed Limit" activated. Speed boards updated across 12 roads.',
    time: '38 min ago',
    severity: NotifSeverity.info,
    district: 'City-Wide',
    icon: Icons.auto_fix_high_rounded,
    category: 'Automation',
    isRead: true,
  ),
  NotificationItem(
    id: 'n6',
    title: 'Sensor Offline — AQ-221',
    body:
        'Air quality sensor in Green Zone is unresponsive. Maintenance ticket #MT-1204 raised.',
    time: '1 hr ago',
    severity: NotifSeverity.warning,
    district: 'Green Zone',
    icon: Icons.sensors_off_rounded,
    category: 'System',
    isRead: true,
  ),
  NotificationItem(
    id: 'n7',
    title: 'City Health Score Updated',
    body: 'Overall city health score changed from 74 to 71. Review dashboard.',
    time: '2 hr ago',
    severity: NotifSeverity.info,
    district: 'City-Wide',
    icon: Icons.monitor_heart_rounded,
    category: 'System',
    isRead: true,
  ),
  NotificationItem(
    id: 'n8',
    title: 'Water Pressure Anomaly',
    body:
        'Residential District water pressure dropped 28% in zones R-12 to R-16. Pump #W-5 restarted.',
    time: '3 hr ago',
    severity: NotifSeverity.warning,
    district: 'Residential District',
    icon: Icons.water_drop_rounded,
    category: 'Utilities',
    isRead: true,
  ),
  NotificationItem(
    id: 'n9',
    title: 'New Automation Rule Active',
    body: 'Rule "Night Mode Lighting" deployed across all districts.',
    time: '5 hr ago',
    severity: NotifSeverity.info,
    district: 'City-Wide',
    icon: Icons.nightlight_round,
    category: 'Automation',
    isRead: true,
  ),
  NotificationItem(
    id: 'n10',
    title: 'Daily Simulation Report Ready',
    body: '24-hour city performance report compiled. 99.2% uptime recorded.',
    time: '8 hr ago',
    severity: NotifSeverity.info,
    district: 'City-Wide',
    icon: Icons.summarize_rounded,
    category: 'System',
    isRead: true,
  ),
];
