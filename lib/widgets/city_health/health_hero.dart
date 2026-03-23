import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/health_ring.dart';
import 'package:urban_os/widgets/city_health/mini_gauge.dart';
import 'package:urban_os/widgets/city_health/stat_row.dart';

typedef C = AppColors;

class HealthHero extends StatelessWidget {
  final double cityHealth, infraHealth;
  final int activeSensors,
      activeAlerts,
      activeRules,
      districts,
      buildings,
      roads;
  final double energyVal, trafficVal, aqiVal, waterVal;
  final AnimationController ringCtrl, radarCtrl, glowCtrl, pulseCtrl;

  const HealthHero({
    super.key,
    required this.cityHealth,
    required this.infraHealth,
    required this.ringCtrl,
    required this.radarCtrl,
    required this.glowCtrl,
    required this.pulseCtrl,
    required this.activeSensors,
    required this.activeAlerts,
    required this.activeRules,
    required this.districts,
    required this.buildings,
    required this.roads,
    required this.energyVal,
    required this.trafficVal,
    required this.aqiVal,
    required this.waterVal,
  });

  Color get _hc => cityHealth >= 85
      ? C.teal
      : cityHealth >= 65
      ? C.amber
      : C.red;
  String get _hl => cityHealth >= 85
      ? 'OPTIMAL'
      : cityHealth >= 65
      ? 'FAIR'
      : 'CRITICAL';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: C.bgCard.withOpacity(.88),
        border: Border.all(color: _hc.withOpacity(.18)),
        boxShadow: [BoxShadow(color: _hc.withOpacity(.07), blurRadius: 28)],
      ),
      child: Column(
        children: [
          // ── Title row
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: _hc,
                  boxShadow: [BoxShadow(color: _hc, blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'CITY HEALTH INDEX',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  letterSpacing: 2.5,
                  color: C.mutedLt,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _hc.withOpacity(.1),
                  border: Border.all(color: _hc.withOpacity(.4)),
                ),
                child: Text(
                  _hl,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    letterSpacing: 2,
                    color: _hc,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Ring + side stats
          Row(
            children: [
              HealthRing(
                cityHealth: cityHealth,
                infraHealth: infraHealth,
                ringCtrl: ringCtrl,
                radarCtrl: radarCtrl,
                glowCtrl: glowCtrl,
                pulseCtrl: pulseCtrl,
                color: _hc,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    StatRow(
                      icon: Icons.sensors_rounded,
                      label: 'SENSORS',
                      value: '$activeSensors active',
                      color: C.cyan,
                    ),
                    const SizedBox(height: 10),
                    StatRow(
                      icon: Icons.warning_amber_rounded,
                      label: 'ALERTS',
                      value: '$activeAlerts open',
                      color: C.amber,
                    ),
                    const SizedBox(height: 10),
                    StatRow(
                      icon: Icons.auto_fix_high_rounded,
                      label: 'AUTOMATION',
                      value: '$activeRules rules live',
                      color: C.teal,
                    ),
                    const SizedBox(height: 10),
                    StatRow(
                      icon: Icons.apartment_rounded,
                      label: 'DISTRICTS',
                      value: '$districts zones',
                      color: C.violet,
                    ),
                    const SizedBox(height: 10),
                    StatRow(
                      icon: Icons.business_rounded,
                      label: 'BUILDINGS',
                      value: '$buildings monitored',
                      color: C.cyan,
                    ),
                    const SizedBox(height: 10),
                    StatRow(
                      icon: Icons.route_rounded,
                      label: 'ROADS',
                      value: '$roads segments',
                      color: C.teal,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          // ── 4 KPI mini gauges
          Row(
            children: [
              Expanded(
                child: MiniGauge(
                  label: 'POWER',
                  value: energyVal,
                  max: 600,
                  unit: 'kW',
                  color: C.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniGauge(
                  label: 'TRAFFIC',
                  value: trafficVal,
                  max: 100,
                  unit: '%',
                  color: C.cyan,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniGauge(
                  label: 'AQI',
                  value: aqiVal,
                  max: 300,
                  unit: '',
                  color: aqiVal < 100
                      ? C.teal
                      : aqiVal < 150
                      ? C.amber
                      : C.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniGauge(
                  label: 'WATER',
                  value: waterVal,
                  max: 100,
                  unit: '%',
                  color: C.violet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
