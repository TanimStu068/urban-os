import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef T = AppColors;

class BatteryBar extends StatelessWidget {
  final int percent;
  const BatteryBar({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = percent > 50
        ? T.green
        : percent > 20
        ? T.amber
        : T.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'BAT',
              style: TextStyle(
                color: T.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 4,
            backgroundColor: T.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
