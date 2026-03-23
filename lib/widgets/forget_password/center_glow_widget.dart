import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CenterGlow extends StatelessWidget {
  final Animation<double> anim;
  const CenterGlow({super.key, required this.anim});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) => Center(
      child: Transform.scale(
        scale: 1 + anim.value * .1,
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.amber.withOpacity(.025 + anim.value * .015),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
