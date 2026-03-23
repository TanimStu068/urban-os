import 'package:flutter/material.dart';
import 'package:urban_os/widgets/scenario_builder/stat_item.dart';

class StatsBar extends StatelessWidget {
  final int activeScenarios;
  final int totalScenarios;
  final int totalSteps;
  final double avgSuccess;

  const StatsBar({
    Key? key,
    required this.activeScenarios,
    required this.totalScenarios,
    required this.totalSteps,
    required this.avgSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.teal.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem('ACTIVE', '$activeScenarios', C.green),
          StatItem('TOTAL', '$totalScenarios', C.teal),
          StatItem('STEPS', '$totalSteps', C.cyan),
          StatItem('SUCCESS', '${avgSuccess.toStringAsFixed(0)}%', C.yellow),
        ],
      ),
    );
  }
}
