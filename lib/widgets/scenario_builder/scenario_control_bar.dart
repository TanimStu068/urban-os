import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/scenario_builder/filter_chip_widget.dart';

typedef C = AppColors;

class ControlBar extends StatelessWidget {
  final String filterStatus;
  final String sortBy;
  final bool showBuilder;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onShowBuilderChanged;

  const ControlBar({
    super.key,
    required this.filterStatus,
    required this.sortBy,
    required this.showBuilder,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onShowBuilderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard2.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: [
          // Status filter
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'ALL',
                    isSelected: filterStatus == 'ALL',
                    color: C.teal,
                    onTap: () => onFilterChanged('ALL'),
                  ),
                  const SizedBox(width: 4),
                  ...<String>['ACTIVE', 'DRAFT', 'COMPLETED'].map(
                    (status) => FilterChipWidget(
                      label: status,
                      isSelected: filterStatus == status,
                      color: status == 'ACTIVE'
                          ? C.green
                          : status == 'DRAFT'
                          ? C.yellow
                          : C.teal,
                      onTap: () => onFilterChanged(status),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Sort button
          GestureDetector(
            onTap: () {
              onSortChanged(sortBy == 'RECENT' ? 'COMPLEXITY' : 'RECENT');
            },
            child: Icon(
              sortBy == 'RECENT'
                  ? Icons.schedule_rounded
                  : Icons.layers_rounded,
              color: C.cyan,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          // Show builder button
          GestureDetector(
            onTap: () => onShowBuilderChanged(!showBuilder),
            child: Icon(
              showBuilder ? Icons.close_rounded : Icons.add_rounded,
              color: C.teal,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
