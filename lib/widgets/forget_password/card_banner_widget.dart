import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class CardBanner extends StatelessWidget {
  final String title;
  final String sub;
  final IconData icon;
  final Color color;

  const CardBanner({
    super.key,
    required this.title,
    required this.sub,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color.withOpacity(.18))),
        color: color.withOpacity(.05),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.12),
              border: Border.all(color: color.withOpacity(.3)),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: color,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.glassBdr),
              color: AppColors.glassBg,
            ),
            child: const Text(
              'AES-256',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: AppColors.cyanDim,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
