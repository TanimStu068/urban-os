import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class SeverityBadge extends StatelessWidget {
  final String severity;
  final bool isActive;
  final double blinkT;
  const SeverityBadge(this.severity, this.isActive, this.blinkT);
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
        isActive && severity == 'HIGH' ? .1 + blinkT * .05 : .08,
      ),
      border: Border.all(
        color: _col.withOpacity(
          isActive && severity == 'HIGH' ? .4 + blinkT * .2 : .25,
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
