import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class DataKpi extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final String? sub;
  const DataKpi(this.value, this.label, this.color, this.sub, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bgCard2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                color: color,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (sub != null)
              Text(
                sub!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6.5,
                  color: AppColors.mutedLt,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
