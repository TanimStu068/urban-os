import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class SignalIllustration extends StatelessWidget {
  final AnimationController anim;
  const SignalIllustration({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) {
      final t = anim.value;
      return SizedBox(
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(3, (i) {
              final delay = i / 3.0;
              final progress = ((t + delay) % 1.0);
              return Transform.scale(
                scale: .5 + progress * .8,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.cyan.withOpacity((1 - progress) * .3),
                      width: .8,
                    ),
                  ),
                ),
              );
            }),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyan.withOpacity(.1),
                border: Border.all(color: AppColors.cyan.withOpacity(.5)),
              ),
              child: const Icon(
                Icons.email_outlined,
                color: AppColors.cyan,
                size: 18,
              ),
            ),
          ],
        ),
      );
    },
  );
}
