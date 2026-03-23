import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/widgets/automation_rule/filter_dropdown.dart';

typedef C = AppColors;
typedef OnSearchChanged = void Function(String);
typedef OnFilterChanged<T> = void Function(T? value);

class RuleSearchAndFilter extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final RuleCategory? catFilter;
  final RuleStatus? statFilter;
  final OnSearchChanged onSearchChanged;
  final OnFilterChanged<RuleCategory?> onCategoryChanged;
  final OnFilterChanged<RuleStatus?> onStatusChanged;

  const RuleSearchAndFilter({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.catFilter,
    required this.statFilter,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: C.bgCard.withOpacity(0.88),
                border: Border.all(color: C.gBdr),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(Icons.search_rounded, color: C.mutedLt, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: C.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search rules…',
                        hintStyle: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: C.muted,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.close_rounded,
                          color: C.mutedLt,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilterDropdown<RuleCategory?>(
            value: catFilter,
            hint: 'CAT',
            items: [null, ...RuleCategory.values],
            labelOf: (v) => v == null ? 'ALL CAT' : v.label,
            colorOf: (v) => v == null ? C.mutedLt : v.color,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(width: 6),
          FilterDropdown<RuleStatus?>(
            value: statFilter,
            hint: 'STATUS',
            items: [null, ...RuleStatus.values],
            labelOf: (v) => v == null ? 'ALL' : v.label,
            colorOf: (v) => v == null ? C.mutedLt : v.color,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}
