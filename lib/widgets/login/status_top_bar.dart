import 'package:flutter/material.dart';
import 'package:urban_os/widgets/login/dot_widget.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class StatusTopBar extends StatelessWidget {
  const StatusTopBar({super.key});
  @override
  Widget build(BuildContext context) => Positioned(
    top: 48,
    left: 0,
    right: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dot(color: AppColors.teal, label: 'SYSTEMS ONLINE', delay: 0),
        const SizedBox(width: 20),
        Dot(color: AppColors.amber, label: 'SECURE MODE', delay: 400),
        const SizedBox(width: 20),
        Dot(color: AppColors.cyan, label: 'v4.2.1', delay: 800),
      ],
    ),
  );
}
