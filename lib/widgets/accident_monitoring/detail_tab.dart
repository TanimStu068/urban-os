import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

const kAccent = C.teal;

class DetailTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const DetailTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['OVERVIEW', 'TIMELINE', 'RESPONSE', 'IMPACT'];
    final icons = [
      Icons.dashboard_rounded,
      Icons.timeline_rounded,
      Icons.local_fire_department_rounded,
      Icons.radar_rounded,
    ];

    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.88),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: isSelected
                      ? kAccent.withOpacity(0.12)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: kAccent.withOpacity(0.4))
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[i],
                      color: isSelected ? kAccent : C.muted,
                      size: 13,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        letterSpacing: 0.8,
                        color: isSelected ? kAccent : C.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
