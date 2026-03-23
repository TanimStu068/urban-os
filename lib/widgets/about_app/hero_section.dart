import 'package:flutter/material.dart';
import 'dart:math';

class HeroSection extends StatelessWidget {
  final AnimationController orbitController;
  final AnimationController entryController;

  const HeroSection({
    super.key,
    required this.orbitController,
    required this.entryController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.5),
          radius: 1.2,
          colors: [Color(0xFF0D1B2E), Color(0xFF070B14)],
        ),
      ),
      child: AnimatedBuilder(
        animation: orbitController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Orbiting rings
              for (int r = 1; r <= 3; r++)
                Transform.rotate(
                  angle:
                      orbitController.value *
                      2 *
                      pi *
                      (r.isEven ? 1 : -1) *
                      0.3,
                  child: Container(
                    width: 80.0 + r * 50,
                    height: 80.0 + r * 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(
                          0xFF00D4FF,
                        ).withOpacity(0.05 + 0.03 * r),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              // Center icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D4FF).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xFF00D4FF).withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hexagon_outlined,
                  color: Color(0xFF00D4FF),
                  size: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
