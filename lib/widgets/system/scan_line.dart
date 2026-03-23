import 'package:flutter/material.dart';

class ScanLine extends StatelessWidget {
  final AnimationController ctrl;
  const ScanLine({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final offsetY = h * ctrl.value;
        return Positioned(
          top: offsetY,
          left: 0,
          right: 0,
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF00D4FF).withOpacity(0.12),
                  const Color(0xFF00D4FF).withOpacity(0.25),
                  const Color(0xFF00D4FF).withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
