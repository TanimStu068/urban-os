import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';

class PhaseChip extends StatelessWidget {
  final SimPhase phase;
  final double blinkT;
  const PhaseChip(this.phase, this.blinkT, {super.key});
  @override
  Widget build(BuildContext ctx) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: phase.color.withOpacity(
        phase == SimPhase.running ? 0.10 + blinkT * 0.04 : 0.08,
      ),
      border: Border.all(
        color: phase.color.withOpacity(
          phase == SimPhase.running ? 0.4 + blinkT * 0.15 : 0.3,
        ),
      ),
    ),
    child: Text(
      phase.label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 8,
        fontWeight: FontWeight.w700,
        color: phase.color,
        letterSpacing: 0.5,
      ),
    ),
  );
}
