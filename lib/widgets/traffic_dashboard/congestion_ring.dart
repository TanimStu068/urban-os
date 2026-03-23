import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/traffic_dashboard/simple_arc.dart';

typedef C = AppColors;

class CongestionRing extends StatelessWidget {
  final int pct;
  final Color color;
  final double glowT;
  const CongestionRing({
    super.key,
    required this.pct,
    required this.color,
    required this.glowT,
  });
  @override
  Widget build(BuildContext ctx) => SizedBox(
    width: 64,
    height: 64,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: SimpleArc(color, pct / 100, glowT),
          size: const Size(64, 64),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$pct%',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: color,
                shadows: [Shadow(color: color.withOpacity(.5), blurRadius: 6)],
              ),
            ),
            const Text(
              'FLOW',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6,
                color: C.muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
