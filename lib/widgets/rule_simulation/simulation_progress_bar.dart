import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/tick_mark_painter.dart';

class SimulationProgressBar extends StatelessWidget {
  final SimPhase phase;
  final double progress;
  final int currentTick;
  final int totalTicks;
  final Animation<double> glowAnimation;
  final List<SimTick> ticks;
  const SimulationProgressBar({
    super.key,
    required this.phase,
    required this.progress,
    required this.currentTick,
    required this.totalTicks,
    required this.glowAnimation,
    required this.ticks,
  });

  @override
  Widget build(BuildContext context) {
    final color = phase == SimPhase.running
        ? C.green
        : phase == SimPhase.paused
        ? C.amber
        : phase == SimPhase.completed
        ? C.teal
        : C.muted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'SIMULATION PROGRESS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: C.muted,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%  ·  $currentTick / $totalTicks',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: C.mutedLt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: glowAnimation,
          builder: (_, __) => Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: C.bgCard,
              border: Border.all(color: C.gBdr),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 200),
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                    ),
                    boxShadow: phase == SimPhase.running
                        ? [
                            BoxShadow(
                              color: color.withOpacity(
                                0.4 + glowAnimation.value * 0.2,
                              ),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 14,
          child: CustomPaint(
            painter: TickMarkPainter(ticks: ticks, total: totalTicks),
            size: const Size(double.infinity, 14),
          ),
        ),
      ],
    );
  }
}
