import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/scenario_builder_data_model.dart';

class StepRow extends StatelessWidget {
  final ScenarioStep step;

  const StepRow({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: step.trigger.color.withOpacity(0.08),
        border: Border.all(color: step.trigger.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: step.trigger.color.withOpacity(0.15),
            ),
            child: Center(
              child: Text(
                '${step.order}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7,
                  color: step.trigger.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  step.action,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6,
                    color: C.mutedLt,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: step.trigger.color.withOpacity(0.2),
            ),
            child: Column(
              children: [
                Text(
                  step.trigger.label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 5,
                    color: step.trigger.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (step.delaySeconds > 0)
                  Text(
                    '+${(step.delaySeconds / 60).toStringAsFixed(1)}m',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 5,
                      color: step.trigger.color.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
