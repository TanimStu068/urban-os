import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';

typedef C = AppColors;

class RangeBar extends StatelessWidget {
  final TimeRange currentRange;
  final ValueChanged<TimeRange> onRangeSelected;

  const RangeBar({
    super.key,
    required this.currentRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.7),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: TimeRange.values.map((r) {
          final isSel = r == currentRange;
          return Expanded(
            child: GestureDetector(
              onTap: () => onRangeSelected(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSel ? C.amber.withOpacity(0.18) : Colors.transparent,
                  border: isSel
                      ? Border.all(color: C.amber.withOpacity(0.45))
                      : null,
                ),
                child: Center(
                  child: Text(
                    r.label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: isSel ? C.amber : C.mutedLt,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.normal,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
