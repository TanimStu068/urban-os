import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FilterTabs extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onTabSelected;

  const FilterTabs({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = ['ALL', 'ACTIVE', 'CRITICAL', 'CLEARED'];
    final colors = [C.teal, C.amber, C.red, C.green]; // use kAccent if needed

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.88),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSel = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSel
                      ? colors[i].withOpacity(0.14)
                      : Colors.transparent,
                  border: isSel
                      ? Border.all(color: colors[i].withOpacity(0.4))
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      letterSpacing: 1.2,
                      color: isSel ? colors[i] : C.muted,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
