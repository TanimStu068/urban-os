import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class LabeledBar extends StatelessWidget {
  final String label;
  final double val;
  final Color col;
  const LabeledBar(this.label, this.val, this.col);
  @override
  Widget build(BuildContext ctx) => Row(
    children: [
      SizedBox(
        width: 100,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: C.mutedLt,
          ),
        ),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              Container(height: 5, color: col.withOpacity(.1)),
              FractionallySizedBox(
                widthFactor: val.clamp(0, 1),
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [col.withOpacity(.5), col],
                    ),
                    boxShadow: [
                      BoxShadow(color: col.withOpacity(.3), blurRadius: 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        '${(val * 100).toStringAsFixed(0)}%',
        style: TextStyle(fontFamily: 'monospace', fontSize: 7.5, color: col),
      ),
    ],
  );
}
