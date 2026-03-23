import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/side_deco.dart';

class SideDecorations extends StatelessWidget {
  const SideDecorations({super.key});
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Left
        Positioned(left: 32, top: h / 2 - 80, child: SideDeco(isLeft: true)),
        // Right
        Positioned(right: 32, top: h / 2 - 80, child: SideDeco(isLeft: false)),
      ],
    );
  }
}
