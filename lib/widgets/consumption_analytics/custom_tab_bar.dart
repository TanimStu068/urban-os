import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';

typedef C = AppColors;

class CustomTabBar extends StatelessWidget {
  final ViewTab selectedTab;
  final int anomalyCount;
  final ValueChanged<ViewTab> onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.anomalyCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (ViewTab.overview, Icons.dashboard_rounded, 'OVERVIEW'),
      (ViewTab.districts, Icons.location_city_rounded, 'DISTRICTS'),
      (ViewTab.categories, Icons.category_rounded, 'CATEGORIES'),
      (ViewTab.costs, Icons.payments_rounded, 'COSTS'),
      (ViewTab.anomalies, Icons.auto_graph_rounded, 'ANOMALIES'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: tabs.map((t) {
          final isSelected = t.$1 == selectedTab;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSelected
                      ? C.violet.withOpacity(0.14)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: C.violet.withOpacity(0.4))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.$2,
                      color: isSelected ? C.violet : C.mutedLt,
                      size: 10,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        t.$3,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: isSelected ? C.violet : C.mutedLt,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (t.$1 == ViewTab.anomalies && anomalyCount > 0) ...[
                      const SizedBox(width: 3),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: C.red,
                        ),
                        child: Center(
                          child: Text(
                            '$anomalyCount',
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
        }).toList(),
      ),
    );
  }
}
