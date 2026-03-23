import 'package:flutter/material.dart';
import 'package:urban_os/widgets/forget_password/dash_ring_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

class LockIllustration extends StatelessWidget {
  final AnimationController anim;
  const LockIllustration({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) {
      final t = anim.value;
      return SizedBox(
        height: 90,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.amber.withOpacity(.15 + t * .1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withOpacity(.1 + t * .08),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.amber.withOpacity(.05 + t * .04),
                border: Border.all(
                  color: AppColors.amber.withOpacity(.2 + t * .1),
                ),
              ),
            ),
            Icon(
              Icons.lock_outline_rounded,
              color: AppColors.amber.withOpacity(.7 + t * .3),
              size: 30,
            ),
            Transform.rotate(
              angle: t * pi * 2,
              child: SizedBox(
                width: 88,
                height: 88,
                child: CustomPaint(
                  painter: DashRingPainter(
                    AppColors.amber.withOpacity(.3 + t * .2),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
