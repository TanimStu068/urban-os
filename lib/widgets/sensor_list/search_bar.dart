import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';

typedef _T = AppColors;

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final SortMode sortMode;
  final bool sortAsc;
  final ValueChanged<SortMode> onSortChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.sortMode,
    required this.sortAsc,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: _T.surfaceMd,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _T.border),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: const TextStyle(
                  color: _T.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Search sensors, type, location…',
                  hintStyle: const TextStyle(
                    color: _T.textSecondary,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _T.textSecondary,
                    size: 18,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            controller.clear();
                            onChanged('');
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            color: _T.textSecondary,
                            size: 16,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Sort picker
          GestureDetector(
            onTap: () => _showSortSheet(context),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _T.surfaceMd,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _T.border),
              ),
              child: Row(
                children: [
                  Icon(
                    sortAsc
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: _T.cyan,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sortLabels[sortMode] ?? 'Sort',
                    style: const TextStyle(
                      color: _T.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: _T.surfaceMd,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _T.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.sort_rounded, color: _T.cyan, size: 18),
                SizedBox(width: 10),
                Text(
                  'Sort Sensors',
                  style: TextStyle(
                    color: _T.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...SortMode.values.map(
            (m) => ListTile(
              onTap: () {
                onSortChanged(m);
                Navigator.pop(ctx);
              },
              leading: Icon(
                sortMode == m
                    ? (sortAsc
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded)
                    : Icons.radio_button_unchecked_rounded,
                color: sortMode == m ? _T.cyan : _T.textSecondary,
                size: 18,
              ),
              title: Text(
                sortLabels[m]!,
                style: TextStyle(
                  color: sortMode == m ? _T.cyan : _T.textPrimary,
                  fontSize: 14,
                  fontWeight: sortMode == m ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
