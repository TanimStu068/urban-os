import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

typedef TabSelectCallback = void Function(ViewTab tab);

class DashboardTabBar extends StatelessWidget {
  final ViewTab currentTab;
  final int unackAlerts;
  final TabSelectCallback onTabSelected;

  const DashboardTabBar({
    super.key,
    required this.currentTab,
    required this.unackAlerts,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (ViewTab.overview, Icons.dashboard_rounded, 'OVERVIEW'),
      (ViewTab.airQuality, Icons.air_rounded, 'AIR QUALITY'),
      (ViewTab.climate, Icons.thermostat_rounded, 'CLIMATE'),
      (ViewTab.noise, Icons.graphic_eq_rounded, 'NOISE'),
      (ViewTab.water, Icons.water_rounded, 'WATER'),
      (ViewTab.alerts, Icons.notifications_active_rounded, 'ALERTS'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.bgCard.withOpacity(0.7),
        border: Border.all(color: AppColors.gBdr),
      ),
      child: Row(
        children: tabs.map((t) {
          final isSelected = t.$1 == currentTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSelected
                      ? AppColors.teal.withOpacity(0.14)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: AppColors.teal.withOpacity(0.4))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.$2,
                      color: isSelected ? AppColors.teal : AppColors.mutedLt,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        t.$3,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: isSelected
                              ? AppColors.teal
                              : AppColors.mutedLt,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (t.$1 == ViewTab.alerts && unackAlerts > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.red,
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
        }).toList(),
      ),
    );
  }
}
