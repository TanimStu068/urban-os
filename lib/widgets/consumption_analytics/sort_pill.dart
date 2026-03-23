import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SortPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const SortPill(this.label, this.selected, this.onTap, {super.key});
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 130),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: selected ? C.amber.withOpacity(0.12) : C.bgCard.withOpacity(0.6),
        border: Border.all(color: selected ? C.amber.withOpacity(0.4) : C.gBdr),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7.5,
          color: selected ? C.amber : C.muted,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    ),
  );
}
