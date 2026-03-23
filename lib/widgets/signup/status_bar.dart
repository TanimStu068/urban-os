import 'package:flutter/material.dart';
import 'package:urban_os/widgets/signup/dot_widget.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Dot(color: AppColors.teal, label: 'SYSTEMS ONLINE', delay: 0),
      const SizedBox(width: 18),
      Dot(color: AppColors.amber, label: 'REGISTRATION OPEN', delay: 300),
      const SizedBox(width: 18),
      Dot(color: AppColors.cyan, label: 'v4.2.1', delay: 600),
    ],
  );
}
