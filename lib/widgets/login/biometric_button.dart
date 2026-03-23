import 'package:flutter/material.dart';
import 'package:urban_os/screens/main_bottom_nav/main_scaffold.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BiometricButton extends StatefulWidget {
  const BiometricButton({super.key});
  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends State<BiometricButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffold()),
          (route) => false,
        );
      },
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.glassBorder.withOpacity(0.5 + _c.value * 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint_rounded,
                color: AppColors.cyan.withOpacity(0.6 + _c.value * 0.4),
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'BIOMETRIC LOGIN',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: AppColors.mutedLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
