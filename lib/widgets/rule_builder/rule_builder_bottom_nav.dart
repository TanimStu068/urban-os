import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/automation_rule_builder_data_model.dart';

typedef C = AppColors;

class RuleBuilderBottomNav extends StatelessWidget {
  final BuilderStep currentStep;
  final AnimationController glowCtrl;
  final bool isReviewStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSave;
  final bool isExistingRule;

  const RuleBuilderBottomNav({
    super.key,
    required this.currentStep,
    required this.glowCtrl,
    required this.onBack,
    required this.onNext,
    required this.onSave,
    this.isReviewStep = false,
    this.isExistingRule = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: C.gBdr)),
        color: C.bgCard.withOpacity(0.9),
      ),
      child: Row(
        children: [
          if (currentStep != BuilderStep.identity)
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: C.bgCard2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: C.gBdr),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_rounded, color: C.mutedLt, size: 14),
                    SizedBox(width: 5),
                    Text(
                      'BACK',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: isReviewStep
                ? GestureDetector(
                    onTap: onSave,
                    child: AnimatedBuilder(
                      animation: glowCtrl,
                      builder: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              C.green.withOpacity(0.3),
                              C.cyan.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: C.green.withOpacity(
                              0.5 + glowCtrl.value * 0.1,
                            ),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: C.green.withOpacity(
                                0.15 + glowCtrl.value * 0.08,
                              ),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: C.green,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isExistingRule ? 'UPDATE RULE' : 'SAVE RULE',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: C.green,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: C.cyan.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: C.cyan.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'NEXT',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: C.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: C.cyan,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
