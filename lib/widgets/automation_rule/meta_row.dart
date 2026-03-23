import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class MetaRow extends StatelessWidget {
  final String label, value;
  const MetaRow(this.label, this.value);
  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label  ',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.mutedLt,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
