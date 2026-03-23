import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class SensorRow extends StatelessWidget {
  final String sensorId;
  final int index;
  final Color color;
  const SensorRow(this.sensorId, this.index, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: color.withOpacity(0.18)),
    ),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(Icons.sensors_rounded, color: color, size: 12),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            sensorId,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AppColors.white,
            ),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    ),
  );
}
