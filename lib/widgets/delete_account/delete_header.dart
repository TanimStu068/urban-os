import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DeleteHeader extends StatelessWidget {
  final Animation<double> glowCtrl;
  final Animation<double> redPulse;

  const DeleteHeader({
    super.key,
    required this.glowCtrl,
    required this.redPulse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: C.bgCard.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: C.red.withOpacity(0.25))),
          boxShadow: [
            BoxShadow(
              color: C.red.withOpacity(0.04 + glowCtrl.value * 0.04),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: C.cyan,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: redPulse,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.red.withOpacity(0.10 + redPulse.value * 0.08),
                  border: Border.all(
                    color: C.red.withOpacity(0.3 + redPulse.value * 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.red.withOpacity(0.15 + redPulse.value * 0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: C.red,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [C.red, Color(0xFFFF6B6B)],
                    ).createShader(bounds),
                    child: const Text(
                      'DELETE ACCOUNT',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    'Permanent & Irreversible Action',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      letterSpacing: 1.4,
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
