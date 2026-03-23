import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/widgets/sensor_list/header_btn.dart';
import 'package:flutter/material.dart';

typedef _T = AppColors;

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final ViewMode viewMode;
  final VoidCallback onToggleView;
  final VoidCallback onToggleFilters;
  final bool filtersActive;
  final int totalSensors;
  final int onlineCount;

  const Header({
    super.key,
    required this.onBack,
    required this.viewMode,
    required this.onToggleView,
    required this.onToggleFilters,
    required this.filtersActive,
    required this.totalSensors,
    required this.onlineCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _T.border)),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _T.surfaceMd,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _T.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _T.textPrimary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title block
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'SENSOR',
                      style: TextStyle(
                        color: _T.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$onlineCount / $totalSensors nodes active',
                  style: const TextStyle(color: _T.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),

          // Actions
          HeaderBtn(
            icon: viewMode == ViewMode.list
                ? Icons.grid_view_rounded
                : Icons.view_agenda_rounded,
            onTap: onToggleView,
            active: false,
          ),
          const SizedBox(width: 8),
          HeaderBtn(
            icon: Icons.tune_rounded,
            onTap: onToggleFilters,
            active: filtersActive,
            activeColor: _T.cyan,
          ),
          const SizedBox(width: 8),
          HeaderBtn(icon: Icons.add_rounded, onTap: () {}, active: false),
        ],
      ),
    );
  }
}
