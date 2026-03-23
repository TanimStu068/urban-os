import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class TopBrand extends StatelessWidget {
  const TopBrand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.amber.withOpacity(.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withOpacity(.2),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.amber,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.amber, AppColors.white],
                ).createShader(b),
                child: const Text(
                  'ACCESS\nRECOVERY',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'SECURE CREDENTIAL RESET',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  letterSpacing: 3,
                  color: AppColors.cyanDim,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: 220,
        height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, AppColors.amber, Colors.transparent],
          ),
        ),
      ),
    ],
  );
}
