import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';

typedef C = AppColors;

class RuleBuilderStepBar extends StatelessWidget {
  final BuilderStep currentStep;
  final AnimationController glowCtrl;
  final bool Function(BuilderStep step) isStepComplete;
  final void Function(BuilderStep step) onStepTap;

  const RuleBuilderStepBar({
    super.key,
    required this.currentStep,
    required this.glowCtrl,
    required this.isStepComplete,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['IDENTITY', 'CONDITIONS', 'ACTIONS', 'SCHEDULE', 'REVIEW'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: BuilderStep.values.map((step) {
            final idx = BuilderStep.values.indexOf(step);
            final isActive = step == currentStep;
            final isComplete = isStepComplete(step);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onStepTap(step),
                child: AnimatedBuilder(
                  animation: glowCtrl,
                  builder: (_, __) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? C.cyan.withOpacity(0.15) : C.bgCard2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? C.cyan.withOpacity(0.5 + glowCtrl.value * 0.1)
                            : isComplete
                            ? C.green.withOpacity(0.3)
                            : C.gBdr,
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        isComplete && !isActive
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: C.green,
                                size: 14,
                              )
                            : Text(
                                '${idx + 1}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  color: isActive ? C.cyan : C.mutedLt,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        const SizedBox(width: 6),
                        Text(
                          labels[idx],
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8.5,
                            color: isActive ? C.cyan : C.muted,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
