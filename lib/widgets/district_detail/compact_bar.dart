import 'package:flutter/material.dart';

class CompactBar extends StatelessWidget {
  final String label;
  final double value, max;
  final Color color;
  const CompactBar(this.label, this.value, this.max, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6.5,
                color: color,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Stack(
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (value / max).clamp(0.0, 1.0),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
