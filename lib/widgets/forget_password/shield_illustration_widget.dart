import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class ShieldIllustration extends StatelessWidget {
  const ShieldIllustration({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.teal.withOpacity(.05),
              border: Border.all(color: AppColors.teal.withOpacity(.2)),
            ),
          ),
          const Icon(Icons.security_rounded, color: AppColors.teal, size: 38),
        ],
      ),
    );
  }
}
