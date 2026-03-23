import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class AlertBanner extends StatelessWidget {
  final AnimationController blinkCtrl;
  final AnimationController glowCtrl;
  final int criticalCount;
  final String message;

  const AlertBanner({
    Key? key,
    required this.blinkCtrl,
    required this.glowCtrl,
    required this.criticalCount,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (criticalCount == 0) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([blinkCtrl, glowCtrl]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: C.red.withOpacity(0.07 + blinkCtrl.value * 0.04),
          border: Border.all(
            color: C.red.withOpacity(0.35 + blinkCtrl.value * 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: C.red.withOpacity(0.1 * blinkCtrl.value),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            // Blinking dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.red.withOpacity(0.6 + blinkCtrl.value * 0.4),
                boxShadow: [
                  BoxShadow(
                    color: C.red.withOpacity(0.6 * blinkCtrl.value),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Message text
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.red.withOpacity(0.85),
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Live indicator
            Text(
              'LIVE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                letterSpacing: 2,
                color: C.red.withOpacity(0.7 + glowCtrl.value * 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
