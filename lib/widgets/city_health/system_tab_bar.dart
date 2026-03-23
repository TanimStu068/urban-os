import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SystemTabBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  final int alertCount, sensorCount, ruleCount;
  final double infraScore;
  const SystemTabBar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.alertCount,
    required this.sensorCount,
    required this.ruleCount,
    required this.infraScore,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('OVERVIEW', Icons.dashboard_rounded, C.teal, ''),
      ('SENSORS $sensorCount', Icons.sensors_rounded, C.cyan, ''),
      ('INFRA ${infraScore.toInt()}%', Icons.business_rounded, C.violet, ''),
      (
        'ALERTS $alertCount',
        Icons.warning_amber_rounded,
        alertCount > 0 ? C.red : C.mutedLt,
        '',
      ),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 42,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final (label, icon, color, _) = tabs[i];
          final sel = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: sel
                      ? color.withOpacity(.12)
                      : C.bgCard.withOpacity(.6),
                  border: Border.all(
                    color: sel ? color.withOpacity(.4) : C.gBdr,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 12, color: sel ? color : C.muted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          letterSpacing: 1,
                          color: sel ? color : C.muted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
