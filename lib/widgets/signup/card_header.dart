import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/signup_data_model.dart';

class CardHeader extends StatelessWidget {
  final int step;
  static const _icons = [
    Icons.person_outline_rounded,
    Icons.admin_panel_settings_outlined,
    Icons.lock_outline_rounded,
  ];

  const CardHeader({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBdr)),
        color: AppColors.cyan.withOpacity(.04),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cyan.withOpacity(.1),
              border: Border.all(color: AppColors.glassBdr),
            ),
            child: Icon(_icons[step], color: AppColors.cyan, size: 15),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[step],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: AppColors.cyan,
                ),
              ),
              Text(
                subtitles[step],
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.glassBdr),
              color: AppColors.glassBg,
            ),
            child: Text(
              '${step + 1}/3',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 10,
                color: AppColors.cyanDim,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
