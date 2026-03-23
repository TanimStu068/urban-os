import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/sensor_list/filter_chip.dart';

typedef _T = AppColors;

class FiltersPanel extends StatelessWidget {
  final bool showOfflineOnly;
  final bool showAlertOnly;
  final VoidCallback onToggleOffline;
  final VoidCallback onToggleAlert;

  const FiltersPanel({
    super.key,
    required this.showOfflineOnly,
    required this.showAlertOnly,
    required this.onToggleOffline,
    required this.onToggleAlert,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _T.surfaceMd,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _T.borderHi),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_rounded, color: _T.cyan, size: 16),
          const SizedBox(width: 10),
          const Text(
            'QUICK FILTERS',
            style: TextStyle(
              color: _T.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          FilterChipWidget(
            label: 'Offline Only',
            active: showOfflineOnly,
            color: _T.orange,
            onTap: onToggleOffline,
          ),
          const SizedBox(width: 8),
          FilterChipWidget(
            label: 'Alerts Only',
            active: showAlertOnly,
            color: _T.red,
            onTap: onToggleAlert,
          ),
        ],
      ),
    );
  }
}
