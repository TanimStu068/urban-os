import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SeverityBadge extends StatelessWidget {
  final String severity;
  final bool isActive;
  final double blinkT;
  const SeverityBadge(this.severity, this.isActive, this.blinkT, {super.key});

  Color get _col => severity == 'HIGH'
      ? C.red
      : severity == 'MEDIUM'
      ? C.amber
      : severity == 'LOW'
      ? C.teal
      : C.green;

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: _col.withOpacity(
        isActive && severity == 'HIGH' ? 0.1 + blinkT * 0.05 : 0.08,
      ),
      border: Border.all(
        color: _col.withOpacity(
          isActive && severity == 'HIGH' ? 0.4 + blinkT * 0.2 : 0.25,
        ),
      ),
    ),
    child: Text(
      severity,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 7,
        letterSpacing: 1,
        color: _col,
      ),
    ),
  );
}
