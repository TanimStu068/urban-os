import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class VDiv extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Container(
    width: 1,
    height: 30,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    color: C.gBdr,
  );
}
