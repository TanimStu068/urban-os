import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/dashboard/city_health_screen.dart';
import 'package:urban_os/widgets/city_dashboard/health_ring.dart';
import 'package:urban_os/widgets/city_dashboard/mini_stat.dart';

typedef C = AppColors;

class CityHealthHero extends StatelessWidget {
  final double health;
  final int sensors, alerts, automations, districtCount, onlineDistricts;
  final AnimationController ringCtrl, glowCtrl, radarCtrl;
  const CityHealthHero({
    super.key,
    required this.health,
    required this.sensors,
    required this.alerts,
    required this.automations,
    required this.districtCount,
    required this.onlineDistricts,
    required this.ringCtrl,
    required this.glowCtrl,
    required this.radarCtrl,
  });

  Color get _hc => health >= 85
      ? C.teal
      : health >= 65
      ? C.amber
      : C.red;
  String get _hl => health >= 85
      ? 'OPTIMAL'
      : health >= 65
      ? 'MODERATE'
      : 'CRITICAL';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CityHealthScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: C.bgCard.withOpacity(.85),
          border: Border.all(color: C.gBdr),
          boxShadow: [BoxShadow(color: _hc.withOpacity(.08), blurRadius: 30)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HealthRing(
                  health: health,
                  ringCtrl: ringCtrl,
                  radarCtrl: radarCtrl,
                  color: _hc,
                  glowCtrl: glowCtrl,
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      MiniStat(
                        icon: Icons.sensors_rounded,
                        label: 'ACTIVE SENSORS',
                        value: '$sensors',
                        color: C.cyan,
                      ),
                      const SizedBox(height: 12),
                      MiniStat(
                        icon: Icons.warning_amber_rounded,
                        label: 'ACTIVE ALERTS',
                        value: '$alerts',
                        color: C.amber,
                      ),
                      const SizedBox(height: 12),
                      MiniStat(
                        icon: Icons.auto_fix_high_rounded,
                        label: 'AUTOMATIONS',
                        value: '$automations LIVE',
                        color: C.teal,
                      ),
                      const SizedBox(height: 12),
                      MiniStat(
                        icon: Icons.apartment_rounded,
                        label: 'DISTRICTS',
                        value: '$onlineDistricts / $districtCount ONLINE',
                        color: C.violet,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
