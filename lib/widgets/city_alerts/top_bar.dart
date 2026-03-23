import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TopBarWidget extends StatelessWidget {
  final int totalActive, criticalCount;
  final AnimationController blinkCtrl;
  const TopBarWidget({
    super.key,
    required this.totalActive,
    required this.criticalCount,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      decoration: BoxDecoration(
        color: C.bgCard.withOpacity(.85),
        border: Border(bottom: BorderSide(color: C.red.withOpacity(.2))),
      ),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.gBg,
                border: Border.all(color: C.gBdr),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: C.mutedLt,
                size: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [C.red, C.amber],
                  ).createShader(b),
                  child: const Text(
                    'ALERT CENTER',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  'REAL-TIME INCIDENT MONITORING',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 2,
                    color: C.mutedLt,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Critical badge
          if (criticalCount > 0)
            Flexible(
              child: AnimatedBuilder(
                animation: blinkCtrl,
                builder: (_, __) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: C.red.withOpacity(.1 + blinkCtrl.value * .08),
                    border: Border.all(
                      color: C.red.withOpacity(.5 + blinkCtrl.value * .3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: C.red.withOpacity(.6 + blinkCtrl.value * .4),
                          boxShadow: [
                            BoxShadow(
                              color: C.red.withOpacity(.6 * blinkCtrl.value),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$criticalCount CRITICAL',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: C.red,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Total count
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.red.withOpacity(.1),
              border: Border.all(color: C.red.withOpacity(.4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$totalActive',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: C.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
