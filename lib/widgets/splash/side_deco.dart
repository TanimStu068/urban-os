import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class SideDeco extends StatelessWidget {
  final bool isLeft;
  const SideDeco({super.key, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    final widths = [40.0, 24.0, 56.0, 16.0, 32.0];
    return Column(
      crossAxisAlignment: isLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        ...widths.map(
          (w) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              width: w,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                  colors: [AppColors.cyan, Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        RotatedBox(
          quarterTurns: isLeft ? 1 : 3,
          child: Text(
            isLeft ? 'URBAN CONTROL OS' : 'V4.2.1 — BUILD 2026',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 3,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}
