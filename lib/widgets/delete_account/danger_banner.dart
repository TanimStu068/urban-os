import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DangerBanner extends StatelessWidget {
  final Animation<double> redPulse;

  const DangerBanner({super.key, required this.redPulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: redPulse,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: C.red.withOpacity(0.07 + redPulse.value * 0.04),
          border: Border.all(
            color: C.red.withOpacity(0.3 + redPulse.value * 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: C.red.withOpacity(0.85 + redPulse.value * 0.15),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CRITICAL WARNING',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.red,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'This will permanently erase your UrbanOS account and all associated city data. This action cannot be undone.',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      color: C.white.withOpacity(0.75),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
