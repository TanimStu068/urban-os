import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DistrictTabs extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onTabChanged;

  const DistrictTabs({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  static const _labels = ['OVERVIEW', 'SENSORS', 'ACTUATORS', 'HISTORY'];
  static const _icons = [
    Icons.dashboard_rounded,
    Icons.sensors_rounded,
    Icons.bolt_rounded,
    Icons.history_rounded,
  ];
  static const _colors = [C.cyan, C.green, C.amber, C.violet];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: C.bgCard2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(4, (i) {
          final active = currentTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: active
                      ? _colors[i].withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: active
                        ? _colors[i].withOpacity(0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icons[i],
                      size: 12,
                      color: active ? _colors[i] : C.mutedLt,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _labels[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 7,
                        letterSpacing: 0.8,
                        color: active ? _colors[i] : C.mutedLt,
                        fontWeight: active
                            ? FontWeight.bold
                            : FontWeight.normal,
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
