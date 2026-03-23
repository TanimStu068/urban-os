import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class VDiv extends StatelessWidget {
  const VDiv({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 30,
    color: AppColors.gBdr,
    margin: const EdgeInsets.symmetric(horizontal: 6),
  );
}
