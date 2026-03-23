import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/auth/login_screen.dart';

class SuccessView extends StatelessWidget {
  final AnimationController anim;
  const SuccessView({super.key, required this.anim});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: anim,
        builder: (_, __) {
          final t = CurvedAnimation(
            parent: anim,
            curve: Curves.elasticOut,
          ).value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: t.clamp(0.0, 1.0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal.withOpacity(.12),
                    border: Border.all(color: AppColors.teal, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withOpacity(.3),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.teal,
                    size: 46,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Opacity(
                opacity: anim.value.clamp(0.0, 1.0),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [AppColors.teal, AppColors.cyan],
                      ).createShader(b),
                      child: const Text(
                        'ACCESS GRANTED',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your operator account has been created.\nAwaiting admin approval.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: AppColors.muted,
                        letterSpacing: .5,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBdr),
                          color: AppColors.glassBg,
                        ),
                        child: const Text(
                          'PROCEED TO LOGIN →',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 12,
                            letterSpacing: 2,
                            color: AppColors.cyan,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
