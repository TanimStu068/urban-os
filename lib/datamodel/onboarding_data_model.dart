import 'package:flutter/material.dart';
import 'package:urban_os/widgets/onboarding/onboarding_data.dart';

final List<OnboardingData> pages = [
  OnboardingData(
    title: 'Urban Digital Twin',
    subtitle: 'A living mirror of the city',
    description:
        'UrbanOS creates a real-time digital replica of every district, road, building, and sensor in your city — giving you omniscient control.',
    icon: Icons.location_city_rounded,
    accentColor: const Color(0xFF00D4FF),
    gradientColors: [const Color(0xFF0A0E1A), const Color(0xFF0D1B2E)],
    tags: ['Districts', 'Buildings', 'Roads', 'Zones'],
  ),
  OnboardingData(
    title: 'Virtual IoT Sensors',
    subtitle: '200+ simulated data streams',
    description:
        'Traffic counters, air quality monitors, power meters, fire detectors — every sensor feeds live data into the automation engine 24/7.',
    icon: Icons.sensors_rounded,
    accentColor: const Color(0xFF00FF9D),
    gradientColors: [const Color(0xFF0A1A0F), const Color(0xFF0D2018)],
    tags: ['Traffic', 'Environment', 'Energy', 'Safety'],
  ),
  OnboardingData(
    title: 'Automation Engine',
    subtitle: 'Rules that think for the city',
    description:
        'Define IF-THEN rules that autonomously control traffic lights, emergency systems, energy grids, and public services with zero manual input.',
    icon: Icons.auto_fix_high_rounded,
    accentColor: const Color(0xFFFF6B35),
    gradientColors: [const Color(0xFF1A0D08), const Color(0xFF2E1508)],
    tags: ['Rules', 'Triggers', 'Actions', 'Priority'],
  ),
  OnboardingData(
    title: 'Mission Control',
    subtitle: 'One dashboard. Entire city.',
    description:
        'Unified analytics, real-time alerts, scenario simulation, and predictive intelligence — command your city like never before.',
    icon: Icons.dashboard_rounded,
    accentColor: const Color(0xFFB44FFF),
    gradientColors: [const Color(0xFF120A1A), const Color(0xFF1C0D2E)],
    tags: ['Analytics', 'Alerts', 'Simulation', 'Reports'],
  ),
];
