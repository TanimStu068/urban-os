import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DashboardTabBar extends StatelessWidget {
  final int selectedIndex;
  final int unackAlerts;
  final void Function(int index) onTabChanged;

  const DashboardTabBar({
    super.key,
    required this.selectedIndex,
    required this.unackAlerts,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('OVERVIEW', Icons.dashboard_rounded),
      ('GRID MAP', Icons.grid_4x4_rounded),
      ('SOURCES', Icons.power_input_rounded),
      ('ALERTS', Icons.notifications_active_rounded),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSel = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSel ? C.amber.withOpacity(0.14) : Colors.transparent,
                  border: isSel
                      ? Border.all(color: C.amber.withOpacity(0.4))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[i].$2,
                      color: isSel ? C.amber : C.mutedLt,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tabs[i].$1,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: isSel ? C.amber : C.mutedLt,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.normal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (i == 3 && unackAlerts > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: C.red,
                        ),
                        child: Center(
                          child: Text(
                            '$unackAlerts',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
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
