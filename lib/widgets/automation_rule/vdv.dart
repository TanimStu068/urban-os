import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class VDiv extends StatelessWidget {
  const VDiv({super.key});
  @override
  Widget build(BuildContext ctx) => Container(
    width: 1,
    height: 28,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: C.gBdr,
  );
}
