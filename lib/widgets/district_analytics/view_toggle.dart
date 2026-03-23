import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class ViewToggle extends StatelessWidget {
  final int viewMode;
  final ValueChanged<int> onChanged;

  const ViewToggle({
    super.key,
    required this.viewMode,
    required this.onChanged,
  });

  static const labels = ['RADAR', 'BAR CHART', 'VS CITY'];
  static const icons = [
    Icons.radar_rounded,
    Icons.bar_chart_rounded,
    Icons.compare_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: C.bgCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: List.generate(3, (i) {
          final active = viewMode == i;

          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: active
                    ? C.violet.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: active ? C.violet.withValues(alpha: 0.5) : C.gBdr,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icons[i],
                    size: 11,
                    color: active ? C.violet : C.mutedLt,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: active ? C.violet : C.mutedLt,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
