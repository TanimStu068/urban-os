import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 36,
    color: C.gBdr,
    margin: const EdgeInsets.symmetric(horizontal: 4),
  );
}
