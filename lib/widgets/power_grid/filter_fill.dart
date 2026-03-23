import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const FilterPill(
    this.label,
    this.selected,
    this.onTap, {
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    final c = color ?? C.amber;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selected ? c.withOpacity(0.15) : C.bgCard.withOpacity(0.6),
          border: Border.all(color: selected ? c.withOpacity(0.45) : C.gBdr),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: selected ? c : C.muted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
