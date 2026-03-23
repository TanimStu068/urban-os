import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_detail_data_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/providers/district/district_provider.dart';

typedef C = AppColors;

class DistrictFilterBar extends StatefulWidget {
  final DistrictProvider districtProvider;
  final DistrictType? initialFilter;
  final ValueChanged<DistrictType?> onFilterChanged;

  const DistrictFilterBar({
    super.key,
    required this.districtProvider,
    this.initialFilter,
    required this.onFilterChanged,
  });

  @override
  State<DistrictFilterBar> createState() => _DistrictFilterBarState();
}

class _DistrictFilterBarState extends State<DistrictFilterBar> {
  DistrictType? _typeFilter;

  @override
  void initState() {
    super.initState();
    _typeFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final dp = widget.districtProvider;
    final typeCounts = dp.districtTypeCounts;
    final types = [
      null,
      ...DistrictType.values.where((t) => (typeCounts[t] ?? 0) > 0),
    ];

    return Container(
      height: 36,
      color: C.bgCard2,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final t = types[i];
          final active = _typeFilter == t;
          final col = t == null ? C.cyan : typeColor(t);
          final label = t == null
              ? 'ALL (${dp.totalDistricts})'
              : '${t.displayName} (${typeCounts[t] ?? 0})';

          return GestureDetector(
            onTap: () {
              setState(() => _typeFilter = t);
              widget.onFilterChanged(t);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: active ? col.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: active ? col.withOpacity(0.5) : C.gBdr,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    letterSpacing: 0.8,
                    color: active ? col : C.mutedLt,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
