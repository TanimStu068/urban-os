import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/hex_painter.dart';

class HexAccents extends StatelessWidget {
  const HexAccents({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 80,
          left: 80,
          child: CustomPaint(painter: HexPainter(), size: const Size(48, 48)),
        ),
        Positioned(
          top: 80,
          right: 80,
          child: CustomPaint(painter: HexPainter(), size: const Size(48, 48)),
        ),
      ],
    );
  }
}
