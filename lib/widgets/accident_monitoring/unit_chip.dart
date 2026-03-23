import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.teal;

class UnitChip extends StatelessWidget {
  final String unit;
  final double glowT;
  const UnitChip({super.key, required this.unit, required this.glowT});

  Color get _col {
    if (unit.startsWith('AMB')) return C.red;
    if (unit.startsWith('POL')) return kAccent;
    if (unit.startsWith('FIR')) return C.orange;
    return C.amber;
  }

  IconData get _icon {
    if (unit.startsWith('AMB')) return Icons.local_hospital_rounded;
    if (unit.startsWith('POL')) return Icons.local_police_rounded;
    if (unit.startsWith('FIR')) return Icons.local_fire_department_rounded;
    return Icons.local_shipping_rounded;
  }

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: _col.withOpacity(0.08 + glowT * 0.03),
      border: Border.all(color: _col.withOpacity(0.3 + glowT * 0.08)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, color: _col, size: 12),
        const SizedBox(width: 5),
        Text(
          unit,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: _col,
          ),
        ),
      ],
    ),
  );
}
