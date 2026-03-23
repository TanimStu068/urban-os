import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';

typedef C = AppColors;

class PeriodBar extends StatelessWidget {
  final TrendPeriod period;
  final Function(TrendPeriod) onPeriodChanged;

  const PeriodBar({
    super.key,
    required this.period,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: C.bgCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'PERIOD',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.mutedLt,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(TrendPeriod.values.length, (i) {
                  final p = TrendPeriod.values[i];
                  final active = period == p;

                  return GestureDetector(
                    onTap: () => onPeriodChanged(p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? C.cyan.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: active ? C.cyan.withOpacity(0.5) : C.gBdr,
                        ),
                      ),
                      child: Text(
                        p.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          letterSpacing: 1,
                          color: active ? C.cyan : C.mutedLt,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const Spacer(),

          Text(
            '${period.buckets} BUCKETS · ${period.unit.toUpperCase()} INTERVALS',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              color: C.mutedLt,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
