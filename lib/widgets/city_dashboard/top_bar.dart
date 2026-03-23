import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TopBar extends StatelessWidget {
  final int alerts;
  final AnimationController blinkCtrl;
  const TopBar({super.key, required this.alerts, required this.blinkCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: C.gBdr)),
        color: C.bgCard.withOpacity(.6),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.bgCard,
              border: Border.all(color: C.gBdr),
              boxShadow: [
                BoxShadow(color: C.cyan.withOpacity(.2), blurRadius: 10),
              ],
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: C.cyan,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [C.cyan, C.teal],
                  ).createShader(b),
                  child: const Text(
                    'UrbanOS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Text(
                  'CITY CONTROL CENTER',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 2.5,
                    color: C.cyanDim,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const Spacer(),

          // Live badge
          AnimatedBuilder(
            animation: blinkCtrl,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: C.green.withOpacity(.08 + blinkCtrl.value * .05),
                border: Border.all(
                  color: C.green.withOpacity(.3 + blinkCtrl.value * .2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.green.withOpacity(.5 + blinkCtrl.value * .5),
                      boxShadow: [
                        BoxShadow(
                          color: C.green.withOpacity(.5 * blinkCtrl.value),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      letterSpacing: 2,
                      color: C.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Alert bell
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: alerts > 0 ? C.red.withOpacity(.1) : C.gBg,
                  border: Border.all(
                    color: alerts > 0 ? C.red.withOpacity(.4) : C.gBdr,
                  ),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: alerts > 0 ? C.red : C.mutedLt,
                  size: 18,
                ),
              ),
              if (alerts > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.red,
                    ),
                    child: Center(
                      child: Text(
                        '$alerts',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),

          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [C.cyanDim, C.teal]),
              border: Border.all(color: C.gBdr, width: 1.5),
            ),
            child: const Center(
              child: Text(
                'JA',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
