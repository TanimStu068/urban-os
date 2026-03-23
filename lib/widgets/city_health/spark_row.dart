import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/city_health/spark_painter.dart';

typedef C = AppColors;

class SparkRow extends StatelessWidget {
  final String label, unit;
  final List<double> data;
  final Color color;
  final AnimationController ctrl;
  const SparkRow({
    super.key,
    required this.label,
    required this.data,
    required this.color,
    required this.unit,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final last = data.isNotEmpty ? data.last : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
                boxShadow: [BoxShadow(color: color, blurRadius: 4)],
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                letterSpacing: 2,
                color: C.mutedLt,
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: ctrl,
              builder: (_, __) => Text(
                '${last.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                  shadows: [
                    Shadow(color: color.withOpacity(.4), blurRadius: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 40,
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (_, __) => CustomPaint(
              painter: SparkPainter(data: List.from(data), color: color),
              size: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }
}
