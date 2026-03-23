import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CircleBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  const CircleBtn(this.icon, {required this.size});

  @override
  Widget build(BuildContext ctx) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: C.gBg,
      border: Border.all(color: C.gBdr),
    ),
    child: Icon(icon, color: C.mutedLt, size: size),
  );
}
