import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

/// A reusable header for the Event Logs screen
class EventsHeader extends StatelessWidget {
  final Animation<double> glowAnimation;
  final int filteredCount;
  final int totalEvents;
  final VoidCallback? onBack;

  const EventsHeader({
    super.key,
    required this.glowAnimation,
    required this.filteredCount,
    required this.totalEvents,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.gBdr)),
          boxShadow: [
            BoxShadow(
              color: C.sky.withOpacity(0.04 + glowAnimation.value * 0.02),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: C.teal,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.sky.withOpacity(0.10),
                border: Border.all(
                  color: C.sky.withOpacity(0.3 + glowAnimation.value * 0.18),
                ),
              ),
              child: const Icon(
                Icons.description_rounded,
                color: C.sky,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.sky, C.cyan],
                    ).createShader(bounds),
                    child: const Text(
                      'EVENT LOGS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '$filteredCount logs  ·  $totalEvents total',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.8,
                      color: C.mutedLt,
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
