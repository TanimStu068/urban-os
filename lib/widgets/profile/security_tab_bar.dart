import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/profile/tab_button.dart';

typedef C = AppColors;

class SecurityTabBar extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const SecurityTabBar({
    super.key,
    required this.selectedTab,
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
            label: 'SECURITY',
            isSelected: selectedTab == 0,
            color: C.red,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 4),
          TabButton(
            label: 'DEVICES',
            isSelected: selectedTab == 1,
            color: C.cyan,
            onTap: () => onTabChanged(1),
          ),
          const SizedBox(width: 4),
          TabButton(
            label: 'HISTORY',
            isSelected: selectedTab == 2,
            color: C.orange,
            onTap: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}
