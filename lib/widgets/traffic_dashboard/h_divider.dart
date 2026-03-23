import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class HDivider extends StatelessWidget {
  const HDivider({super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    width: 1,
    height: 32,
    margin: const EdgeInsets.symmetric(horizontal: 6),
    color: C.gBdr,
  );
}
