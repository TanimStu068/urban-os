import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CBtn extends StatelessWidget {
  final IconData icon;
  final double sz;
  final VoidCallback? onTap;
  const CBtn(this.icon, {required this.sz, this.onTap, super.key});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: C.gBg,
        border: Border.all(color: C.gBdr),
      ),
      child: Icon(icon, color: C.mutedLt, size: sz),
    ),
  );
}
