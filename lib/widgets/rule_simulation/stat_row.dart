import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class StatRow extends StatelessWidget {
  final String label, value;
  const StatRow(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Text(
          '$label  ',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: C.muted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
