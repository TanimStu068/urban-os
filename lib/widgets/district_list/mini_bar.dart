import 'package:flutter/material.dart';

class MiniBar extends StatelessWidget {
  final String label;
  final double value; // 0–100
  final Color color;
  const MiniBar(this.label, this.value, this.color, {super.key});

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
              '${value.toInt()}',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value.clamp(0, 100) / 100,
              child: Container(
                height: 4,
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
