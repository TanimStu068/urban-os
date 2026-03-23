import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/signup_data_model.dart';

class StepIndicator extends StatelessWidget {
  final int step;
  const StepIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == step;
        final isComplete = i < step;
        return Row(
          children: [
            Column(
              children: [
                // Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? AppColors.teal.withOpacity(.15)
                        : isActive
                        ? AppColors.cyan.withOpacity(.12)
                        : AppColors.bgCard,
                    border: Border.all(
                      color: isComplete
                          ? AppColors.teal
                          : isActive
                          ? AppColors.cyan
                          : AppColors.muted,
                      width: isActive ? 1.5 : 1,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withOpacity(.25),
                              blurRadius: 12,
                            ),
                          ]
                        : isComplete
                        ? [
                            BoxShadow(
                              color: AppColors.teal.withOpacity(.15),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isComplete
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.teal,
                            size: 16,
                          )
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? AppColors.cyan
                                  : AppColors.muted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 1.5,
                    color: isActive
                        ? AppColors.cyan
                        : isComplete
                        ? AppColors.teal
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
            if (i < 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 18, left: 6, right: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 50,
                  height: 1,
                  color: i < step
                      ? AppColors.teal
                      : AppColors.muted.withOpacity(.3),
                ),
              ),
          ],
        );
      }),
    );
  }
}
