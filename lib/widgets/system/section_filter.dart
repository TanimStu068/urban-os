import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';

typedef _C = AppColors;

class SectionFilter extends StatelessWidget {
  final List<Section> sections;
  final int selected;
  final ValueChanged<int> onSelect;

  const SectionFilter({
    super.key,
    required this.sections,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sections.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isAll = i == 0;
          final isActive = selected == i;
          final color = isAll ? _C.cyan : sections[i - 1].color;
          final icon = isAll ? Icons.apps_rounded : sections[i - 1].icon;
          final count = isAll
              ? sections.fold(0, (a, s) => a + s.entries.length)
              : sections[i - 1].entries.length;

          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.15) : _C.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive ? color.withOpacity(0.5) : _C.border,
                  width: isActive ? 1.5 : 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.15),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: isActive ? color : _C.textSub, size: 13),
                  const SizedBox(width: 7),
                  Text(
                    isAll ? 'ALL' : sections[i - 1].label,
                    style: TextStyle(
                      color: isActive ? color : _C.textSub,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isActive ? color : _C.textDim).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isActive ? color : _C.textSub,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
