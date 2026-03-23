import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';

typedef C = AppColors;

class TimeRangeSelector extends StatefulWidget {
  final TimeRange initialRange;
  final ValueChanged<TimeRange>? onChanged;

  const TimeRangeSelector({
    super.key,
    this.initialRange = TimeRange.h24,
    this.onChanged,
  });

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  late TimeRange _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      ('24H', TimeRange.h24),
      ('7 DAYS', TimeRange.day7),
      ('30 DAYS', TimeRange.month30),
      ('YEAR', TimeRange.year),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: options.map((t) {
        return GestureDetector(
          onTap: () {
            setState(() => _selectedRange = t.$2);
            if (widget.onChanged != null) widget.onChanged!(_selectedRange);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _selectedRange == t.$2
                  ? C.teal.withOpacity(0.14)
                  : Colors.transparent,
              border: _selectedRange == t.$2
                  ? Border.all(color: C.teal.withOpacity(0.4))
                  : null,
            ),
            child: Text(
              t.$1,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: _selectedRange == t.$2 ? C.teal : C.mutedLt,
                fontWeight: _selectedRange == t.$2
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
