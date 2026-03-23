import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/auth/forgot_password_screen.dart';

class PhaseTracker extends StatelessWidget {
  final Phase phase;
  const PhaseTracker({super.key, required this.phase});

  int get _phaseIndex => Phase.values.indexOf(phase).clamp(0, 2);

  static const _labels = ['EMAIL', 'VERIFY', 'RESET'];
  static const _icons = [
    Icons.alternate_email_rounded,
    Icons.pin_rounded,
    Icons.lock_open_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == _phaseIndex;
        final isComplete = i < _phaseIndex;
        return Row(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? AppColors.teal.withOpacity(.15)
                        : isActive
                        ? AppColors.amber.withOpacity(.12)
                        : AppColors.bgCard,
                    border: Border.all(
                      color: isComplete
                          ? AppColors.teal
                          : isActive
                          ? AppColors.amber
                          : AppColors.muted,
                      width: isActive ? 1.5 : 1,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.amber.withOpacity(.28),
                              blurRadius: 14,
                            ),
                          ]
                        : isComplete
                        ? [
                            BoxShadow(
                              color: AppColors.teal.withOpacity(.18),
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
                        : Icon(
                            _icons[i],
                            color: isActive ? AppColors.amber : AppColors.muted,
                            size: 15,
                          ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _labels[i],
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 1.5,
                    color: isActive
                        ? AppColors.amber
                        : isComplete
                        ? AppColors.teal
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
            if (i < 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 18, left: 8, right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 40,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: i < _phaseIndex
                          ? [AppColors.teal, AppColors.cyan]
                          : [
                              AppColors.muted.withOpacity(.3),
                              AppColors.muted.withOpacity(.1),
                            ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
