import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class CardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  const CardWidget({super.key, required this.child, required this.margin});
  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: C.bgCard.withOpacity(.88),
      border: Border.all(color: C.gBdr),
    ),
    child: child,
  );
}
