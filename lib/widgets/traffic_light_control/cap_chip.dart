import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class CapChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  const CapChip(this.label, this.icon, this.active);

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(vertical: 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: active ? kAccent.withOpacity(0.07) : C.bgCard2,
      border: Border.all(
        color: active ? kAccent.withOpacity(0.25) : C.muted.withOpacity(0.15),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? kAccent : C.muted.withOpacity(0.3),
          size: 13,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: active ? kAccent.withOpacity(0.7) : C.muted.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? C.green.withOpacity(0.8) : C.red.withOpacity(0.4),
          ),
        ),
      ],
    ),
  );
}
