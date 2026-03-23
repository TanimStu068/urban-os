import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class NavButtons extends StatelessWidget {
  final int step;
  final bool isLoading, agreeTerms;
  final AnimationController loadingCtrl;
  final VoidCallback onNext, onBack, onRegister;

  const NavButtons({
    super.key,
    required this.step,
    required this.isLoading,
    required this.agreeTerms,
    required this.loadingCtrl,
    required this.onNext,
    required this.onBack,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
      child: Row(
        children: [
          // Back button
          if (step > 0)
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.glassBdr),
                    color: AppColors.glassBg,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.mutedLight,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'BACK',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          letterSpacing: 2,
                          color: AppColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Next / Register button
          Expanded(
            flex: step > 0 ? 3 : 1,
            child: GestureDetector(
              onTap: step == 2 ? onRegister : onNext,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: step == 2
                        ? [const Color(0xFF00AA55), AppColors.teal]
                        : [const Color(0xFF006080), AppColors.cyan],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (step == 2 ? AppColors.teal : AppColors.cyan)
                          .withOpacity(.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: (step == 2 ? AppColors.teal : AppColors.cyan)
                        .withOpacity(.4),
                  ),
                ),
                child: isLoading
                    ? Center(
                        child: AnimatedBuilder(
                          animation: loadingCtrl,
                          builder: (_, __) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (i) {
                              final t = (loadingCtrl.value - i * .2).clamp(
                                0.0,
                                1.0,
                              );
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.3 + t * .7),
                                ),
                              );
                            }),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (step == 2) ...[
                            const Icon(
                              Icons.how_to_reg_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'CREATE ACCOUNT',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
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
