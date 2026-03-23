import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class CardHeader extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  const CardHeader(this.title, this.sub, this.icon);
  @override
  Widget build(BuildContext ctx) => Row(
    children: [
      Container(
        width: 3,
        height: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: kAccent,
          boxShadow: [BoxShadow(color: kAccent, blurRadius: 4)],
        ),
      ),
      const SizedBox(width: 7),
      Icon(icon, color: kAccent, size: 12),
      const SizedBox(width: 6),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 1.8,
              color: kAccent,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.muted,
            ),
          ),
        ],
      ),
    ],
  );
}
