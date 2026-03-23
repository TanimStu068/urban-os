import 'package:flutter/material.dart';
import 'package:urban_os/widgets/city_dashboard/spark_line_painter.dart';

class Sparkline extends StatelessWidget {
  final String label, unit;
  final List<double> data;
  final Color color;
  final AnimationController liveCtrl;
  const Sparkline({
    super.key,
    required this.label,
    required this.data,
    required this.color,
    required this.unit,
    required this.liveCtrl,
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
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
                boxShadow: [BoxShadow(color: color, blurRadius: 4)],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 2,
                color: C.mutedLt,
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: liveCtrl,
              builder: (_, __) => Text(
                '${last.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                  shadows: [
                    Shadow(color: color.withOpacity(.5), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: AnimatedBuilder(
            animation: liveCtrl,
            builder: (_, __) => CustomPaint(
              painter: SparklinePainter(data: List.from(data), color: color),
              size: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }
}
