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
  Widget build(BuildContext ctx) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: active ? kAccent.withOpacity(0.07) : C.bgCard2,
        border: Border.all(
          color: active ? kAccent.withOpacity(0.25) : C.muted.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: active ? kAccent : C.muted.withOpacity(0.3),
            size: 14,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 6.5,
              color: active
                  ? kAccent.withOpacity(0.7)
                  : C.muted.withOpacity(0.3),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? C.green.withOpacity(0.8) : C.red.withOpacity(0.4),
            ),
          ),
        ],
      ),
    ),
  );
}
