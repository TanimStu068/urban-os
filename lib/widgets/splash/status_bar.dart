import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/status_dot.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      StatusDot(label: 'SYSTEMS ONLINE', color: AppColors.teal, delay: 0),
      const SizedBox(width: 24),
      StatusDot(label: 'SYNCING DATA', color: AppColors.amber, delay: 500),
      const SizedBox(width: 24),
      StatusDot(label: 'SECURE CONN', color: AppColors.cyan, delay: 1000),
    ],
  );
}
