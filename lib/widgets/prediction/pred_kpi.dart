import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class PredKpi extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;
  final double glow;
  const PredKpi(
    this.value,
    this.label,
    this.color,
    this.icon,
    this.glow, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2 + glow * 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 10),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
