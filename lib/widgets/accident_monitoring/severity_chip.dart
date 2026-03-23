import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';

class SeverityChip extends StatelessWidget {
  final AccidentSeverity severity;
  final double blinkT;
  final bool compact;
  const SeverityChip(this.severity, this.blinkT, {this.compact = false});

  @override
  Widget build(BuildContext ctx) {
    final col = severity.color;
    final isPulse =
        severity == AccidentSeverity.critical ||
        severity == AccidentSeverity.high;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: col.withOpacity(isPulse ? 0.12 + blinkT * 0.05 : 0.08),
        border: Border.all(
          color: col.withOpacity(isPulse ? 0.45 + blinkT * 0.2 : 0.3),
        ),
        boxShadow: isPulse
            ? [BoxShadow(color: col.withOpacity(0.15 * blinkT), blurRadius: 8)]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPulse) ...[
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: col.withOpacity(0.8 + blinkT * 0.2),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            severity.label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: compact ? 6.5 : 8,
              letterSpacing: 0.8,
              color: col,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
