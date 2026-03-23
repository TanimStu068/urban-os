import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';

typedef _C = AppColors;

class CategoryTag extends StatelessWidget {
  final SystemEntry entry;
  const CategoryTag({super.key, required this.entry});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: _C.surfaceHi,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: _C.borderHi),
    ),
    child: Text(
      entry.category.toUpperCase(),
      style: const TextStyle(
        color: _C.textSub,
        fontSize: 8,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    ),
  );
}
