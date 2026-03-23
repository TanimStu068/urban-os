import 'package:urban_os/widgets/help_support/fab_item.dart';
import 'package:flutter/material.dart';

final List<String> categories = [
  'All',
  'Getting Started',
  'Sensors',
  'Automation',
  'Analytics',
  'Technical',
];

final List<FaqItem> faqs = const [
  FaqItem(
    question: 'How do I add a new district to my city?',
    answer:
        'Navigate to Districts > District List and tap the "+" button in the top right corner. You can configure the district type, name, area boundaries, and assign initial sensors and buildings. Each district can host up to 50 buildings and 200 sensors.',
    category: 'Getting Started',
    icon: Icons.location_city_rounded,
  ),
  FaqItem(
    question: 'What is the difference between a Sensor and an Actuator?',
    answer:
        'Sensors are virtual data sources that read environmental, traffic, energy, or safety data. Actuators are control devices that take actions — like switching traffic lights, triggering sirens, or adjusting power grid states. The Automation Engine connects sensors (inputs) to actuators (outputs) through rules.',
    category: 'Sensors',
    icon: Icons.sensors_rounded,
  ),
  FaqItem(
    question: 'How does the Automation Rule Engine work?',
    answer:
        'Rules follow an IF-THEN-PRIORITY format. The engine evaluates all active rules every simulation tick. When a sensor condition is met, the corresponding actuator action executes. Priority levels (1–5) resolve conflicts when multiple rules target the same actuator simultaneously.',
    category: 'Automation',
    icon: Icons.auto_fix_high_rounded,
  ),
  FaqItem(
    question: 'Why is my City Health Score dropping?',
    answer:
        'The Health Score is a composite metric calculated from traffic flow efficiency, energy consumption levels, environmental AQI, active emergency incidents, sensor uptime, and automation rule coverage. Check the City Health Screen for a breakdown of which subsystems are dragging the score.',
    category: 'Analytics',
    icon: Icons.monitor_heart_rounded,
  ),
  FaqItem(
    question: 'How do I simulate an emergency scenario?',
    answer:
        'Go to Simulation > Scenario Builder and choose "Emergency Event". You can inject fire alerts, traffic accidents, grid failures, or mass evacuation events. The simulation runs in isolated mode and shows how your automation rules respond before you deploy them live.',
    category: 'Getting Started',
    icon: Icons.science_rounded,
  ),
  FaqItem(
    question: 'Can I export analytics data and reports?',
    answer:
        'Yes. Navigate to Analytics > Report Generator and select your date range, district filters, and data categories. Reports can be exported as PDF, CSV, or JSON. Scheduled reports can be configured to auto-generate daily, weekly, or monthly.',
    category: 'Analytics',
    icon: Icons.download_rounded,
  ),
  FaqItem(
    question: 'A sensor shows "Offline" status. What should I do?',
    answer:
        'An offline sensor means the simulation engine lost contact with the virtual device. Go to the Sensor Detail Screen and tap "Force Reconnect". If the issue persists, check the sensor simulation parameters or re-initialize it from the Developer Panel.',
    category: 'Sensors',
    icon: Icons.sensors_off_rounded,
  ),
  FaqItem(
    question: 'What do the alert severity levels mean?',
    answer:
        'CRITICAL: Immediate action required — fire, grid failure, emergency. WARNING: Degraded performance or approaching threshold — high AQI, traffic congestion. INFO: System updates, completed automations, reports. All levels are logged in the Alert History screen.',
    category: 'Technical',
    icon: Icons.warning_amber_rounded,
  ),
];
