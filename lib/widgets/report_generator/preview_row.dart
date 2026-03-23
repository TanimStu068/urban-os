import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const PreviewRow(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 70,
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
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
