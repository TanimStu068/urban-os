import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';

typedef _T = AppColors;

class CategoryChips extends StatelessWidget {
  final String? active;
  final ValueChanged<String> onChange;
  final Map<String, int> sensorsPerCat;

  const CategoryChips({
    super.key,
    required this.active,
    required this.onChange,
    required this.sensorsPerCat,
  });

  @override
  Widget build(BuildContext context) {
    final entries = [
      MapEntry<String?, CatMeta?>(null, null), // "All" chip
      ...categoryMeta.entries,
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final key = entries[i].key;
          final meta = entries[i].value;
          final isAll = key == null;
          final isActive = active == key;
          final color = meta?.color ?? _T.cyan;
          final count = isAll
              ? sensorsPerCat.values.fold(0, (a, b) => a + b)
              : (sensorsPerCat[key] ?? 0);

          return GestureDetector(
            onTap: () => onChange(key ?? ''),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.15) : _T.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isActive ? color.withOpacity(0.5) : _T.border,
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAll) ...[
                    Icon(meta!.icon, color: color, size: 13),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    isAll ? 'ALL' : key.toUpperCase(),
                    style: TextStyle(
                      color: isActive ? color : _T.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isActive ? color : _T.textMuted).withOpacity(
                        0.15,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isActive ? color : _T.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
