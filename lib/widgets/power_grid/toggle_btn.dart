import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ToggleBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const ToggleBtn(this.icon, this.label, this.active, this.onTap, {super.key});

  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: active ? C.amber.withOpacity(0.1) : C.bgCard.withOpacity(0.5),
        border: Border.all(color: active ? C.amber.withOpacity(0.35) : C.gBdr),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? C.amber : C.muted, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: active ? C.amber : C.muted,
            ),
          ),
        ],
      ),
    ),
  );
}
