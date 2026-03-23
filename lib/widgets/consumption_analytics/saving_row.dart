import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SavingRow extends StatelessWidget {
  final String desc, saving;
  final Color color;
  final double confidence;
  const SavingRow(
    this.desc,
    this.saving,
    this.color,
    this.confidence, {
    super.key,
  });
  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color.withOpacity(0.05),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Icon(Icons.eco_rounded, color: color, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                desc,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    'CONFIDENCE: ',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      color: C.muted,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: C.muted.withOpacity(0.3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: confidence,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${(confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          saving,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
