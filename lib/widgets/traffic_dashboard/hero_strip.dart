import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/hero_kpi.dart';
import 'package:urban_os/widgets/traffic_dashboard/h_divider.dart';

typedef C = AppColors;
// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class HeroStrip extends StatelessWidget {
  final Map<String, double> liveStats;
  final double glowT, blinkT;
  const HeroStrip({
    super.key,
    required this.liveStats,
    required this.glowT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: C.bgCard.withOpacity(.88),
      border: Border.all(color: kAccent.withOpacity(.18 + glowT * .07)),
      boxShadow: [BoxShadow(color: kAccent.withOpacity(.06), blurRadius: 20)],
    ),
    child: Row(
      children: [
        HeroKpi(
          'TOTAL VEHICLES',
          '${liveStats['vehicles']!.toStringAsFixed(0)}/h',
          kAccent,
          Icons.directions_car_rounded,
          false,
          glowT,
        ),
        HDivider(),
        HeroKpi(
          'AVG SPEED',
          '${liveStats['speed']!.toStringAsFixed(0)} km/h',
          C.teal,
          Icons.speed_rounded,
          false,
          glowT,
        ),
        HDivider(),
        HeroKpi(
          'CONGESTION',
          '${liveStats['congestion']!.toStringAsFixed(0)}%',
          C.amber,
          Icons.traffic_rounded,
          liveStats['congestion']! > 80,
          glowT,
        ),
        HDivider(),
        HeroKpi(
          'INCIDENTS',
          '${liveStats['incidents']!.toStringAsFixed(0)}',
          C.red,
          Icons.warning_amber_rounded,
          liveStats['incidents']! > 0,
          glowT,
        ),
        HDivider(),
        // Live indicator
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.green.withOpacity(.1),
                border: Border.all(color: C.green.withOpacity(.3)),
              ),
              child: Icon(
                Icons.sensors_rounded,
                color: C.green.withOpacity(.7 + glowT * .3),
                size: 16,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'LIVE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                letterSpacing: 2,
                color: C.green.withOpacity(.6 + glowT * .3),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
