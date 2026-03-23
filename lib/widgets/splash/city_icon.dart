import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/city_icon_painter.dart';

class CityIcon extends StatelessWidget {
  final AnimationController glowCtrl;
  const CityIcon({super.key, required this.glowCtrl});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => CustomPaint(
        painter: CityIconPainter(glowCtrl.value),
        size: const Size(70, 70),
      ),
    );
  }
}
