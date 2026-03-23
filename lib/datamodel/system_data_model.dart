import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/energy/consumption_analytics_screen.dart';
import 'package:urban_os/screens/energy/energy_dashboard_screen.dart';
import 'package:urban_os/screens/energy/power_grid_map_screen.dart';
import 'package:urban_os/screens/energy/water_management_screen.dart';
import 'package:urban_os/screens/enviroment/environment_dashboard_screen.dart';
import 'package:urban_os/screens/enviroment/pollution_analytics_screen.dart';
import 'package:urban_os/screens/enviroment/weather_simulation_screen.dart';
import 'package:urban_os/screens/logs/alert_history_screen.dart';
import 'package:urban_os/screens/logs/event_logs_screen.dart';
import 'package:urban_os/screens/safety/cctv_activity_screen.dart';
import 'package:urban_os/screens/safety/emergency_control_system.dart';
import 'package:urban_os/screens/safety/fire_monitoring_screen.dart';
import 'package:urban_os/screens/sensor/sensor_list_screen.dart';
import 'package:urban_os/screens/simulation/event_injection_screen.dart';
import 'package:urban_os/screens/simulation/scenario_builder_screen.dart';
import 'package:urban_os/screens/traffic/accident_monitoring_screen.dart';
import 'package:urban_os/screens/traffic/parking_analytics_screen.dart';
import 'package:urban_os/screens/traffic/road_detail_screen.dart';
import 'package:urban_os/screens/traffic/traffic_dashboard_screen.dart';
import 'package:urban_os/screens/traffic/traffic_light_control_screen.dart';

typedef _C = AppColors;

class SystemEntry {
  final String id;
  final String label;
  final String sublabel;
  final String category;
  final IconData icon;
  final Color accent;
  final Widget Function() builder;
  final TileSize size;
  final bool isHot;
  final String? badge;

  const SystemEntry({
    required this.id,
    required this.label,
    required this.sublabel,
    required this.category,
    required this.icon,
    required this.accent,
    required this.builder,
    this.size = TileSize.medium,
    this.isHot = false,
    this.badge,
  });
}

enum TileSize { wide, medium }

// ═════════════════════════════════════════════════════════════════════════════
//  SECTION GROUPINGS
// ═════════════════════════════════════════════════════════════════════════════
class Section {
  final String label;
  final IconData icon;
  final Color color;
  final List<SystemEntry> entries;
  const Section({
    required this.label,
    required this.icon,
    required this.color,
    required this.entries,
  });
}

List<Section> buildSections() => [
  Section(
    label: 'Energy & Utilities',
    icon: Icons.bolt_rounded,
    color: _C.amber,
    entries: [
      SystemEntry(
        id: 'energy-dash',
        label: 'Energy Dashboard',
        sublabel: 'Grid load · kW usage · gen',
        category: 'Energy',
        icon: Icons.bolt_rounded,
        accent: _C.amber,
        builder: () => const EnergyDashboardScreen(),
        size: TileSize.wide,
        badge: 'LIVE',
      ),
      SystemEntry(
        id: 'power-grid',
        label: 'Power Grid Map',
        sublabel: 'Zone topology · switch states',
        category: 'Energy',
        icon: Icons.hub_rounded,
        accent: _C.orange,
        builder: () => const PowerGridMapScreen(),
        size: TileSize.medium,
      ),
      SystemEntry(
        id: 'water-mgmt',
        label: 'Water Management',
        sublabel: 'Pump status · flow rates',
        category: 'Energy',
        icon: Icons.water_drop_rounded,
        accent: _C.blue,
        builder: () => const WaterManagementScreen(),
        size: TileSize.medium,
      ),
      SystemEntry(
        id: 'consumption',
        label: 'Consumption Analytics',
        sublabel: 'Trend charts · usage reports',
        category: 'Energy',
        icon: Icons.analytics_rounded,
        accent: _C.teal,
        builder: () => const ConsumptionAnalyticsScreen(),
        size: TileSize.medium,
      ),
    ],
  ),
  Section(
    label: 'Environment',
    icon: Icons.eco_rounded,
    color: _C.green,
    entries: [
      SystemEntry(
        id: 'env-dash',
        label: 'Environment Dashboard',
        sublabel: 'AQI · temp · humidity · wind',
        category: 'Environment',
        icon: Icons.public_rounded,
        accent: _C.green,
        builder: () => const EnvironmentDashboardScreen(),
        size: TileSize.wide,
        badge: 'LIVE',
      ),
      SystemEntry(
        id: 'pollution',
        label: 'Pollution Analytics',
        sublabel: 'PM2.5 · CO₂ · AQI trends',
        category: 'Environment',
        icon: Icons.masks_rounded,
        accent: _C.lime,
        builder: () => const PollutionAnalyticsScreen(),
        size: TileSize.medium,
      ),
      SystemEntry(
        id: 'weather',
        label: 'Weather Simulation',
        sublabel: 'Rain · wind · UV · pressure',
        category: 'Environment',
        icon: Icons.thunderstorm_rounded,
        accent: _C.cyan,
        builder: () => const WeatherSimulationScreen(),
        size: TileSize.medium,
      ),
    ],
  ),
  Section(
    label: 'Traffic & Mobility',
    icon: Icons.traffic_rounded,
    color: _C.orange,
    entries: [
      SystemEntry(
        id: 'traffic-dash',
        label: 'Traffic Dashboard',
        sublabel: 'Vehicle flow · congestion · signals',
        category: 'Traffic',
        icon: Icons.traffic_rounded,
        accent: _C.orange,
        builder: () => const TrafficDashboardScreen(),
        size: TileSize.wide,
        badge: 'LIVE',
      ),

      SystemEntry(
        id: 'traffic-light',
        label: 'Traffic Light Control',
        sublabel: 'Signal timing · intersection AI',
        category: 'Traffic',
        icon: Icons.traffic_rounded,
        accent: _C.red,
        builder: () => const TrafficLightControlScreen(),
        size: TileSize.medium,
        isHot: true,
      ),

      SystemEntry(
        id: 'road-details',
        label: 'Road Network',
        sublabel: 'Road stats · lanes · speed limits',
        category: 'Traffic',
        icon: Icons.route_rounded,
        accent: _C.cyan,
        builder: () => RoadDetailScreen(),
        size: TileSize.medium,
      ),

      SystemEntry(
        id: 'parking',
        label: 'Parking Analytics',
        sublabel: 'Capacity · occupancy · zones',
        category: 'Traffic',
        icon: Icons.local_parking_rounded,
        accent: _C.green,
        builder: () => const ParkingAnalyticsScreen(),
        size: TileSize.medium,
      ),

      SystemEntry(
        id: 'accident-monitor',
        label: 'Accident Monitoring',
        sublabel: 'Crash alerts · incident zones',
        category: 'Traffic',
        icon: Icons.car_crash_rounded,
        accent: _C.red,
        builder: () => const AccidentMonitoringScreen(),
        size: TileSize.medium,
        isHot: true,
        badge: 'ALERT',
      ),
    ],
  ),
  Section(
    label: 'Safety & Security',
    icon: Icons.security_rounded,
    color: _C.red,
    entries: [
      SystemEntry(
        id: 'emergency',
        label: 'Emergency Control',
        sublabel: 'Active incidents · dispatch',
        category: 'Safety',
        icon: Icons.emergency_rounded,
        accent: _C.red,
        builder: () => const EmergencyControlSystemScreen(),
        size: TileSize.wide,
        isHot: true,
        badge: 'CRITICAL',
      ),
      SystemEntry(
        id: 'fire-monitor',
        label: 'Fire Monitoring',
        sublabel: 'Detector network · zones',
        category: 'Safety',
        icon: Icons.local_fire_department_rounded,
        accent: _C.orange,
        builder: () => const FireMonitoringScreen(),
        size: TileSize.medium,
        isHot: true,
      ),
      SystemEntry(
        id: 'cctv',
        label: 'CCTV Activity',
        sublabel: 'Camera feeds · motion alerts',
        category: 'Safety',
        icon: Icons.videocam_rounded,
        accent: _C.violet,
        builder: () => const CCTVActivityScreen(),
        size: TileSize.medium,
      ),
    ],
  ),
  Section(
    label: 'Sensors & IoT',
    icon: Icons.sensors_rounded,
    color: _C.cyan,
    entries: [
      SystemEntry(
        id: 'sensor-list',
        label: 'Sensor Array',
        sublabel: 'All 200+ virtual IoT nodes',
        category: 'Sensors',
        icon: Icons.sensors_rounded,
        accent: _C.cyan,
        builder: () => const SensorListScreen(),
        size: TileSize.wide,
        badge: 'ACTIVE',
      ),
    ],
  ),
  Section(
    label: 'Logs & History',
    icon: Icons.history_rounded,
    color: _C.violet,
    entries: [
      SystemEntry(
        id: 'alert-history',
        label: 'Alert History',
        sublabel: 'Critical · warning · info log',
        category: 'Logs',
        icon: Icons.warning_amber_rounded,
        accent: _C.amber,
        builder: () => const AlertHistoryScreen(),
        size: TileSize.medium,
      ),
      SystemEntry(
        id: 'event-log',
        label: 'Event Logs',
        sublabel: 'System events · actions · changes',
        category: 'Logs',
        icon: Icons.receipt_long_rounded,
        accent: _C.violet,
        builder: () => const EventLogsScreen(),
        size: TileSize.medium,
      ),
    ],
  ),
  Section(
    label: 'Simulation Lab',
    icon: Icons.science_rounded,
    color: _C.rose,
    entries: [
      SystemEntry(
        id: 'scenario',
        label: 'Scenario Builder',
        sublabel: 'Build & test city scenarios',
        category: 'Simulation',
        icon: Icons.schema_rounded,
        accent: _C.rose,
        builder: () => const ScenarioBuilderScreen(),
        size: TileSize.wide,
        badge: 'LAB',
      ),
      SystemEntry(
        id: 'event-inject',
        label: 'Event Injection',
        sublabel: 'Inject live city events',
        category: 'Simulation',
        icon: Icons.play_circle_rounded,
        accent: _C.violet,
        builder: () => const EventInjectionScreen(),
        size: TileSize.medium,
      ),
    ],
  ),
];
