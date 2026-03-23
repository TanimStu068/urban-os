import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class LiveChip extends StatefulWidget {
  const LiveChip({super.key});
  @override
  State<LiveChip> createState() => _LiveChipState();
}

class _LiveChipState extends State<LiveChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: C.red.withOpacity(0.07 + _c.value * 0.05),
        border: Border.all(color: C.red.withOpacity(0.25 + _c.value * 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.red.withOpacity(0.6 + _c.value * 0.4),
              boxShadow: [
                BoxShadow(
                  color: C.red.withOpacity(0.5 * _c.value),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'LIVE',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              letterSpacing: 2,
              color: C.red,
            ),
          ),
        ],
      ),
    ),
  );
}
