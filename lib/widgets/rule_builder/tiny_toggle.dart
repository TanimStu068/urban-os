import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TinyToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;
  const TinyToggle({super.key, required this.value, required this.onToggle});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onToggle,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 40,
      height: 22,
      decoration: BoxDecoration(
        color: value ? C.green.withOpacity(0.2) : C.bgCard2,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: value ? C.green.withOpacity(0.5) : C.gBdr),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 150),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: value ? C.green : C.muted,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}
