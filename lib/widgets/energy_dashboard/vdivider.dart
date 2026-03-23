import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class VDivider extends StatelessWidget {
  const VDivider({super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    width: 1,
    height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: C.gBdr,
  );
}
