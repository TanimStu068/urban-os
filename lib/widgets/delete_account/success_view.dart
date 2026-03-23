import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef _C = AppColors;

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.green.withOpacity(0.12),
                  border: Border.all(
                    color: _C.green.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(color: _C.green.withOpacity(0.2), blurRadius: 32),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: _C.green,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ACCOUNT DELETED',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: _C.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your UrbanOS account has been permanently removed.\nRedirecting to login...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: _C.white.withOpacity(0.6),
                height: 1.7,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(_C.green.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
