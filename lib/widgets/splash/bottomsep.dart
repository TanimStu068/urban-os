import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class BottomSep extends StatelessWidget {
  const BottomSep({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.glassBorder,
    );
  }
}
