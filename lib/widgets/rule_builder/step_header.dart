import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';

typedef C = AppColors;

class StepHeader extends StatelessWidget {
  final BuilderStep step;
  final String subtitle;
  const StepHeader({super.key, required this.step, required this.subtitle});
  @override
  Widget build(BuildContext ctx) {
    const labels = [
      'STEP 1: IDENTITY',
      'STEP 2: CONDITIONS',
      'STEP 3: ACTIONS',
      'STEP 4: SCHEDULE',
      'STEP 5: REVIEW',
    ];
    const colors = [C.cyan, C.amber, C.green, C.sky, C.violet];
    final idx = BuilderStep.values.indexOf(step);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors[idx].withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: colors[idx].withOpacity(0.3)),
          ),
          child: Text(
            labels[idx],
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: colors[idx],
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            color: C.mutedLt,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
