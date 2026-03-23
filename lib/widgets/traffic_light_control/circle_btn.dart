import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CircleBtn extends StatelessWidget {
  final IconData icon;
  final double sz;
  const CircleBtn(this.icon, {required this.sz});

  @override
  Widget build(BuildContext ctx) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: C.gBg,
      border: Border.all(color: C.gBdr),
    ),
    child: Icon(icon, color: C.mutedLt, size: sz),
  );
}
