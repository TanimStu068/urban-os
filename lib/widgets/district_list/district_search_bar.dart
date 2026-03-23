import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class DistrictSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<int>? onSortChanged;
  final ValueChanged<bool>? onCriticalToggled;

  const DistrictSearchBar({
    super.key,
    this.onSearchChanged,
    this.onSortChanged,
    this.onCriticalToggled,
  });

  @override
  State<DistrictSearchBar> createState() => _DistrictSearchBarState();
}

class _DistrictSearchBarState extends State<DistrictSearchBar> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int _sortMode = 0;
  bool _criticalOnly = false;

  final List<IconData> _sortIcons = [
    Icons.sort_rounded,
    Icons.arrow_downward_rounded,
    Icons.arrow_upward_rounded,
    Icons.swap_vert_rounded,
  ];

  final List<String> _sortLabels = ['DEFAULT', 'LOW→HIGH', 'HIGH→LOW', 'ALPHA'];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text);
      widget.onSearchChanged?.call(_searchQuery);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.bgCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // ── Search field ──
          Expanded(
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: C.bgCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _searchQuery.isNotEmpty
                      ? C.cyan.withOpacity(0.4)
                      : C.gBdr,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    Icons.search_rounded,
                    color: _searchQuery.isNotEmpty ? C.cyan : C.mutedLt,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: C.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Search districts, types, IDs…',
                        hintStyle: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: C.mutedLt.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                        widget.onSearchChanged?.call('');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.close_rounded,
                          color: C.mutedLt,
                          size: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ── Sort button ──
          GestureDetector(
            onTap: () {
              setState(() => _sortMode = (_sortMode + 1) % _sortIcons.length);
              widget.onSortChanged?.call(_sortMode);
            },
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: C.bgCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: C.cyan.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(_sortIcons[_sortMode], color: C.cyan, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    _sortLabels[_sortMode],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: C.cyan,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // ── Critical toggle ──
          GestureDetector(
            onTap: () {
              setState(() => _criticalOnly = !_criticalOnly);
              widget.onCriticalToggled?.call(_criticalOnly);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _criticalOnly
                    ? C.red.withOpacity(0.12)
                    : C.bgCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _criticalOnly ? C.red.withOpacity(0.5) : C.gBdr,
                ),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: _criticalOnly ? C.red : C.mutedLt,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
