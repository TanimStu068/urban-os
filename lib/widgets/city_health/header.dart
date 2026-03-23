import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/live_badge.dart';

typedef C = AppColors;

class Header extends StatelessWidget {
  final String cityName;
  final int critAlerts;
  final AnimationController alertCtrl;
  const Header({
    super.key,
    required this.cityName,
    required this.critAlerts,
    required this.alertCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      decoration: BoxDecoration(
        color: C.bgCard.withOpacity(.7),
        border: Border(bottom: BorderSide(color: C.gBdr)),
      ),
      child: Row(
        children: [
          // Animated health pulse icon
          AnimatedBuilder(
            animation: alertCtrl,
            builder: (_, __) => Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.bgCard,
                border: Border.all(
                  color: critAlerts > 0
                      ? C.red.withOpacity(.4 + alertCtrl.value * .4)
                      : C.teal.withOpacity(.3 + alertCtrl.value * .2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: critAlerts > 0
                        ? C.red.withOpacity(.15 * alertCtrl.value)
                        : C.teal.withOpacity(.15 * alertCtrl.value),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                Icons.monitor_heart_rounded,
                color: critAlerts > 0 ? C.red : C.teal,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [C.teal, C.cyan],
                  ).createShader(b),
                  child: Text(
                    cityName,
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  'HEALTH MONITOR',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 3,
                    color: C.cyanDim,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (critAlerts > 0)
            Flexible(
              child: AnimatedBuilder(
                animation: alertCtrl,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.red.withOpacity(.08 + alertCtrl.value * .06),
                    border: Border.all(
                      color: C.red.withOpacity(.3 + alertCtrl.value * .3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: C.red.withOpacity(.15 * alertCtrl.value),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: C.red.withOpacity(.5 + alertCtrl.value * .5),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$critAlerts CRITICAL',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          letterSpacing: 1.5,
                          color: C.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          LiveBadge(),
        ],
      ),
    );
  }
}
