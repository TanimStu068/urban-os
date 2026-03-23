import 'package:flutter/material.dart';
import 'water_management_models.dart';
import 'water_management_shared.dart';

class WaterManagementTabBar extends StatelessWidget {
  final int selectedTab;
  final int totalUnacked;
  final int criticalUnacked;
  final ValueChanged<int> onTabChanged;

  const WaterManagementTabBar({
    super.key,
    required this.selectedTab,
    required this.totalUnacked,
    required this.criticalUnacked,
    required this.onTabChanged,
  });

  static const _tabDefs = [
    TabDef('OVERVIEW', Icons.dashboard_rounded),
    TabDef('TANKS', Icons.water_rounded),
    TabDef('NETWORK', Icons.hub_rounded),
    TabDef('PUMPS', Icons.settings_rounded),
    TabDef('QUALITY', Icons.science_rounded),
    TabDef('ALERTS', Icons.notifications_rounded),
  ];

  @override
  Widget build(BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabDefs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final sel = selectedTab == i;
          final hasAlert = i == 5 && totalUnacked > 0;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: sel ? C.cyan.withOpacity(.15) : C.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: sel ? C.cyan.withOpacity(.5) : C.gBdr,
                  width: sel ? 1.2 : 1,
                ),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: C.cyan.withOpacity(.12),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    _tabDefs[i].icon,
                    color: sel ? C.cyan : C.mutedHi,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  WaterLabel(
                    text: _tabDefs[i].label,
                    color: sel ? C.cyan : C.mutedHi,
                    size: 9.5,
                    letterSpacing: .8,
                  ),
                  if (hasAlert) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: criticalUnacked > 0
                            ? C.red.withOpacity(.25)
                            : C.amber.withOpacity(.25),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '$totalUnacked',
                        style: TextStyle(
                          color: criticalUnacked > 0 ? C.red : C.amber,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
