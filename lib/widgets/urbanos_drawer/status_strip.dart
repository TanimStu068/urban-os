import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _K = AppColors;

class StatusStrip extends StatelessWidget {
  final AnimationController hotCtrl;
  const StatusStrip({super.key, required this.hotCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: hotCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _K.green.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _K.green.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _K.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _K.green.withOpacity(0.5 + hotCtrl.value * 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'All systems operational',
                style: TextStyle(
                  color: _K.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '99.9%',
              style: TextStyle(
                color: _K.textSub,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
