import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/developer_panel/tap_button.dart';

typedef C = AppColors;

class DeveloperTabBar extends StatelessWidget {
  final int selectedTab;
  final int logsCount;
  final int metricsCount;
  final int systemCount;
  final Function(int) onTabChanged;

  const DeveloperTabBar({
    super.key,
    required this.selectedTab,
    required this.logsCount,
    required this.metricsCount,
    required this.systemCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard2.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: [
          TabButton(
            label: 'LOGS',
            count: logsCount,
            isSelected: selectedTab == 0,
            color: C.cyan,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 4),
          TabButton(
            label: 'METRICS',
            count: metricsCount,
            isSelected: selectedTab == 1,
            color: C.orange,
            onTap: () => onTabChanged(1),
          ),
          const SizedBox(width: 4),
          TabButton(
            label: 'SYSTEM',
            count: systemCount,
            isSelected: selectedTab == 2,
            color: C.teal,
            onTap: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}
