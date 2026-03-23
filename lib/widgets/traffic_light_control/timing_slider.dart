import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class TimingSlider extends StatelessWidget {
  final String label;
  final int value, min, max;
  final Color col;
  final Function(int) onAdjust;
  final double glowT;
  const TimingSlider(
    this.label,
    this.value,
    this.min,
    this.max,
    this.col,
    this.onAdjust,
    this.glowT,
  );

  @override
  Widget build(BuildContext ctx) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 7.5,
              color: C.mutedLt,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (value > min) onAdjust(-5);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: col.withOpacity(0.08),
              border: Border.all(color: col.withOpacity(0.25)),
            ),
            child: Icon(
              Icons.remove_rounded,
              color: col.withOpacity(0.7),
              size: 11,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: col.withOpacity(0.1),
                ),
              ),
              FractionallySizedBox(
                widthFactor: ((value - min) / (max - min)).clamp(0.0, 1.0),
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [col.withOpacity(0.5), col],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: col.withOpacity(0.3 + glowT * 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            if (value < max) onAdjust(5);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: col.withOpacity(0.08),
              border: Border.all(color: col.withOpacity(0.25)),
            ),
            child: Icon(
              Icons.add_rounded,
              color: col.withOpacity(0.7),
              size: 11,
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 36,
          child: Text(
            '${value}s',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: col,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
