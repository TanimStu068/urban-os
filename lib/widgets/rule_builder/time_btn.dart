import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TimeBtn extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;
  const TimeBtn({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: C.bgCard2,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time.format(ctx),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: C.cyan,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
