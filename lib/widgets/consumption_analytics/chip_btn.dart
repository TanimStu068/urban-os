import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ChipBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  const ChipBtn(this.label, this.active, this.onTap, this.color, {super.key});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: active ? color.withOpacity(0.14) : C.bgCard2,
        border: Border.all(color: active ? color.withOpacity(0.45) : C.gBdr),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7.5,
          color: active ? color : C.muted,
          fontWeight: active ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    ),
  );
}
