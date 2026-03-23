import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class InfoRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const InfoRow(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: AppColors.mutedLt,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Text(
          '· ',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: AppColors.mutedLt,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
