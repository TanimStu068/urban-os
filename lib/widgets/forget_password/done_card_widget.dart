import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/forget_password/card_wrap_widget.dart';
import 'package:urban_os/widgets/forget_password/tick_painter.dart';

class DoneCard extends StatelessWidget {
  final AnimationController anim;
  const DoneCard({required this.anim, super.key});

  @override
  Widget build(BuildContext context) {
    return CardWrap(
      accentColor: AppColors.teal,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: AnimatedBuilder(
          animation: anim,
          builder: (_, __) {
            final t = CurvedAnimation(
              parent: anim,
              curve: Curves.elasticOut,
            ).value.clamp(0.0, 1.0);
            final fade = anim.value.clamp(0.0, 1.0);
            return Column(
              children: [
                Transform.scale(
                  scale: t,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.teal, width: 1.5),
                          color: AppColors.teal.withOpacity(.08),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.teal.withOpacity(.3),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                      ),
                      CustomPaint(
                        painter: TickPainterWidget(anim.value),
                        size: const Size(100, 100),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Opacity(
                  opacity: fade,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: [AppColors.teal, AppColors.cyan],
                        ).createShader(b),
                        child: const Text(
                          'CODE RESET',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'SUCCESSFUL',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6,
                          color: AppColors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your access credentials have been\nupdated. You may now sign in.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: AppColors.mutedLight,
                          letterSpacing: .4,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (_) => false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF006080), AppColors.cyan],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withOpacity(.3),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.cyan.withOpacity(.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.login_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'RETURN TO LOGIN',
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBdr),
                          color: AppColors.glassBg,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.muted,
                              size: 13,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'All previous sessions have been revoked for security.',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 9,
                                  color: AppColors.muted,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
