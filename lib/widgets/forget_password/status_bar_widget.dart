import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/forget_password/dot_widget.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Dot(color: AppColors.amber, label: 'RECOVERY MODE', delay: 0),
      const SizedBox(width: 18),
      Dot(color: AppColors.teal, label: 'ENCRYPTED', delay: 300),
      const SizedBox(width: 18),
      Dot(color: AppColors.cyan, label: 'v4.2.1', delay: 600),
    ],
  );
}
