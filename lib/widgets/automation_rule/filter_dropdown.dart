import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class FilterDropdown<T> extends StatelessWidget {
  final T value;
  final String hint;
  final List<T> items;
  final String Function(T) labelOf;
  final Color Function(T) colorOf;
  final ValueChanged<T> onChanged;

  const FilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.labelOf,
    required this.colorOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext ctx) {
    final col = colorOf(value);
    return GestureDetector(
      onTap: () => _showPicker(ctx),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: C.bgCard.withOpacity(0.88),
          border: Border.all(
            color: value != null ? col.withOpacity(0.4) : C.gBdr,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: col),
            ),
            const SizedBox(width: 6),
            Text(
              labelOf(value),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: col,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: col, size: 12),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: C.bgCard2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: C.muted,
            ),
          ),
          ...items.map((item) {
            final c = colorOf(item);
            return GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                onChanged(item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      labelOf(item),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: c,
                      ),
                    ),
                    if (item == value) ...[
                      const Spacer(),
                      Icon(Icons.check_rounded, color: c, size: 16),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
