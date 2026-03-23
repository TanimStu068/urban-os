import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';

class AlertRow extends StatelessWidget {
  final EnvAlert alert;
  final double blinkT;
  final VoidCallback onAck;
  const AlertRow({
    super.key,
    required this.alert,
    required this.blinkT,
    required this.onAck,
  });
  @override
  Widget build(BuildContext ctx) {
    final c = alert.severity;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: c.withOpacity(
          alert.acknowledged ? 0.02 : 0.06 + (c == C.red ? blinkT * 0.015 : 0),
        ),
        border: Border.all(
          color: c.withOpacity(
            alert.acknowledged
                ? 0.1
                : c == C.red
                ? 0.3 + blinkT * 0.1
                : 0.2,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.withOpacity(0.12),
              border: Border.all(color: c.withOpacity(0.3)),
            ),
            child: Icon(
              alert.icon,
              color: c.withOpacity(alert.acknowledged ? 0.4 : 1),
              size: 12,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.message,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8.5,
                    color: alert.acknowledged ? C.mutedLt : C.white,
                    fontWeight: alert.acknowledged
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${alert.district}  ·  ${alert.time}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.muted,
                  ),
                ),
              ],
            ),
          ),
          if (!alert.acknowledged)
            GestureDetector(
              onTap: onAck,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.withOpacity(0.1),
                  border: Border.all(color: c.withOpacity(0.3)),
                ),
                child: Icon(Icons.check_rounded, color: c, size: 11),
              ),
            )
          else
            Icon(
              Icons.check_circle_outline_rounded,
              color: C.muted.withOpacity(0.5),
              size: 14,
            ),
        ],
      ),
    );
  }
}
