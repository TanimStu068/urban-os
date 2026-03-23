import 'package:flutter/material.dart';
import 'package:urban_os/widgets/onboarding/onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final Animation<double> animation;
  final bool isActive;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.animation,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero icon
              Transform.translate(
                offset: Offset(0, 30 * (1 - animation.value)),
                child: Opacity(
                  opacity: animation.value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: data.accentColor.withOpacity(0.08),
                      border: Border.all(
                        color: data.accentColor.withOpacity(0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: data.accentColor.withOpacity(0.15),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: data.accentColor.withOpacity(0.1),
                            border: Border.all(
                              color: data.accentColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Icon(data.icon, color: data.accentColor, size: 48),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Subtitle
              Transform.translate(
                offset: Offset(0, 20 * (1 - animation.value)),
                child: Opacity(
                  opacity: animation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: data.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: data.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      data.subtitle.toUpperCase(),
                      style: TextStyle(
                        color: data.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Transform.translate(
                offset: Offset(0, 15 * (1 - animation.value)),
                child: Opacity(
                  opacity: animation.value,
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              Opacity(
                opacity: animation.value,
                child: Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                    height: 1.65,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Tags
              Opacity(
                opacity: animation.value,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: data.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
