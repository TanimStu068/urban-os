import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
typedef OnSortChange = void Function(int);

class RuleSortBar extends StatelessWidget {
  final int sortMode;
  final int resultCount;
  final OnSortChange onSortChange;

  const RuleSortBar({
    super.key,
    required this.sortMode,
    required this.resultCount,
    required this.onSortChange,
  });

  static const _sorts = ['PRIORITY', 'TRIGGERS', 'NAME', 'CATEGORY'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Row(
        children: [
          const Text(
            'SORT:',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
            ),
          ),
          const SizedBox(width: 6),
          ...List.generate(_sorts.length, (i) {
            final isSelected = i == sortMode;
            return GestureDetector(
              onTap: () => onSortChange(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isSelected
                      ? C.violet.withOpacity(0.15)
                      : C.bgCard.withOpacity(0.6),
                  border: Border.all(
                    color: isSelected ? C.violet.withOpacity(0.45) : C.gBdr,
                  ),
                ),
                child: Text(
                  _sorts[i],
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: isSelected ? C.violet : C.muted,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.normal,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Text(
            '$resultCount result${resultCount != 1 ? 's' : ''}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.muted,
            ),
          ),
        ],
      ),
    );
  }
}
