import 'package:flutter/material.dart';
import 'package:urban_os/models/automation/rule_priority.dart';

class StatusBadge extends StatelessWidget {
  final RuleStatus status;
  final double blinkT;
  final bool isCompact;
  const StatusBadge(this.status, this.blinkT, {this.isCompact = false});
  @override
  Widget build(BuildContext ctx) {
    final col = status.color;
    final isAnim = status == RuleStatus.triggered || status == RuleStatus.error;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 5 : 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: col.withOpacity(isAnim ? 0.10 + blinkT * 0.05 : 0.07),
        border: Border.all(
          color: col.withOpacity(isAnim ? 0.4 + blinkT * 0.15 : 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAnim) ...[
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: col.withOpacity(0.7 + blinkT * 0.3),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: isCompact ? 6.5 : 7.5,
              color: col,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
