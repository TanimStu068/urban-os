import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

typedef TabChangedCallback = void Function(int);

class FilterTabs extends StatelessWidget {
  final int activeTab;
  final TabChangedCallback onTabChanged;

  const FilterTabs({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['ALL', 'GREEN', 'YELLOW', 'RED'];
    final colors = [kAccent, C.green, C.amber, C.red];

    return Container(
      height: 38,
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.88),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSel = i == activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
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
