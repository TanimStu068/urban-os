import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class Header extends StatelessWidget {
  final AnimationController blinkCtrl;
  final int incidents;
  const Header({super.key, required this.blinkCtrl, required this.incidents});

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    decoration: BoxDecoration(
      color: C.bgCard.withOpacity(.88),
      border: Border(bottom: BorderSide(color: C.gBdr)),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(ctx),
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
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [C.cyan, C.teal],
              ).createShader(b),
              child: const Text(
                'TRAFFIC CONTROL',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              'CITY-WIDE · LIVE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                letterSpacing: 2.5,
                color: C.mutedLt,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Active incidents badge
        AnimatedBuilder(
          animation: blinkCtrl,
          builder: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: C.amber.withOpacity(.08 + blinkCtrl.value * .04),
              border: Border.all(
                color: C.amber.withOpacity(.4 + blinkCtrl.value * .15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: C.amber.withOpacity(.6 + blinkCtrl.value * .4),
                    boxShadow: [
                      BoxShadow(
                        color: C.amber.withOpacity(.5 * blinkCtrl.value),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: C.gBg,
            border: Border.all(color: C.gBdr),
          ),
          child: const Icon(
            Icons.more_vert_rounded,
            color: C.mutedLt,
            size: 18,
          ),
        ),
      ],
    ),
  );
}
