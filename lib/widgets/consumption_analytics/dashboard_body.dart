import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/custom_tab_bar.dart';

typedef C = AppColors;

class DashboardBody extends StatelessWidget {
  final ViewTab selectedTab;
  final int anomalyCount;
  final ValueChanged<ViewTab> onTabSelected;

  final Widget overviewTab;
  final Widget districtsTab;
  final Widget categoriesTab;
  final Widget costsTab;
  final Widget anomaliesTab;

  const DashboardBody({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.anomalyCount,
    required this.overviewTab,
    required this.districtsTab,
    required this.categoriesTab,
    required this.costsTab,
    required this.anomaliesTab,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        CustomTabBar(
          selectedTab: selectedTab,
          anomalyCount: anomalyCount,
          onTabSelected: onTabSelected,
        ),
        // Tab content
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: IndexedStack(
              key: ValueKey(selectedTab),
              index: selectedTab.index,
              children: [
                overviewTab,
                districtsTab,
                categoriesTab,
                costsTab,
                anomaliesTab,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
