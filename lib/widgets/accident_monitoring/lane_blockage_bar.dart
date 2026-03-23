import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class LaneBlockageBar extends StatelessWidget {
  final int total, blocked;
  final double glowT;
  const LaneBlockageBar({
    super.key,
    required this.total,
    required this.blocked,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text(
            'LANES',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.mutedLt,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$blocked/$total BLOCKED',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: blocked > 0 ? C.red : C.green,
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: List.generate(total, (i) {
          final isBlocked = i < blocked;
          return Expanded(
            child: Container(
              height: 14,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isBlocked
                    ? C.red.withOpacity(0.6 + glowT * 0.2)
                    : C.green.withOpacity(0.3),
                border: Border.all(
                  color: isBlocked
                      ? C.red.withOpacity(0.5)
                      : C.green.withOpacity(0.2),
                ),
                boxShadow: isBlocked
                    ? [
                        BoxShadow(
                          color: C.red.withOpacity(0.3 + glowT * 0.15),
                          blurRadius: 6,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  isBlocked ? 'BLOCKED' : 'OPEN',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 5.5,
                    letterSpacing: 0.5,
                    color: isBlocked ? C.red : C.green.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ],
  );
}
