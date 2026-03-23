import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/system/hex_logo.dart';

typedef _C = AppColors;

class TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final int totalModules;
  final int hotCount;
  final AnimationController hotCtrl;
  final AnimationController orbitCtrl;

  const TopBar({
    super.key,
    required this.onBack,
    required this.totalModules,
    required this.hotCount,
    required this.hotCtrl,
    required this.orbitCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _C.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _C.surfaceMd,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _C.text,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          HexLogo(orbitCtrl: orbitCtrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      const Text(
                        'SYSTEM',
                        style: TextStyle(
                          color: _C.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _C.cyan.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _C.cyan.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'MATRIX',
                          style: TextStyle(
                            color: _C.cyan,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalModules modules · city control layer',
                  style: const TextStyle(color: _C.textSub, fontSize: 11),
                ),
              ],
            ),
          ),
          if (hotCount > 0)
            AnimatedBuilder(
              animation: hotCtrl,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _C.red.withOpacity(0.1 + hotCtrl.value * 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _C.red.withOpacity(0.3 + hotCtrl.value * 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _C.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _C.red.withOpacity(0.8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
