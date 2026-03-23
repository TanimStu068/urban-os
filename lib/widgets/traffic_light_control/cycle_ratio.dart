import 'package:flutter/material.dart';

class CycleRatio extends StatelessWidget {
  final String label;
  final int dur, total;
  final Color col;
  const CycleRatio(this.label, this.dur, this.total, this.col);

  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.only(bottom: 1),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label  ${(dur / total * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: col.withOpacity(0.7),
          ),
        ),
      ],
    ),
  );
}
