import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';

class AlertDetailRow extends StatelessWidget {
  final EnergyAlert alert;
  final double blinkT;
  final VoidCallback onAck;

  const AlertDetailRow({
    super.key,
    required this.alert,
    required this.blinkT,
    required this.onAck,
  });

  Color get _col {
    switch (alert.level) {
      case AlertLevel.critical:
        return C.red;
      case AlertLevel.warning:
        return C.amber;
      case AlertLevel.info:
        return C.cyan;
    }
  }

  String get _levelLabel {
    switch (alert.level) {
      case AlertLevel.critical:
        return 'CRITICAL';
      case AlertLevel.warning:
        return 'WARNING';
      case AlertLevel.info:
        return 'INFO';
    }
  }

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: _col.withOpacity(
        alert.acknowledged
            ? 0.02
            : 0.05 + (alert.level == AlertLevel.critical ? blinkT * 0.02 : 0),
      ),
      border: Border.all(
        color: _col.withOpacity(
          alert.acknowledged
              ? 0.1
              : alert.level == AlertLevel.critical
              ? 0.3 + blinkT * 0.1
              : 0.2,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _col.withOpacity(0.1),
                border: Border.all(color: _col.withOpacity(0.3)),
              ),
              child: Text(
                _levelLabel,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: _col,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              alert.id,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: C.mutedLt,
              ),
            ),
            const Spacer(),
            Text(
              alert.time,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: C.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          alert.message,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9.5,
            color: alert.acknowledged ? C.mutedLt : C.white,
            fontWeight: alert.acknowledged
                ? FontWeight.normal
                : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on_outlined, color: C.muted, size: 11),
            const SizedBox(width: 4),
            Text(
              alert.zone,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.muted,
              ),
            ),
            const Spacer(),
            if (!alert.acknowledged)
              GestureDetector(
                onTap: onAck,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _col.withOpacity(0.1),
                    border: Border.all(color: _col.withOpacity(0.3)),
                  ),
                  child: Text(
                    'ACKNOWLEDGE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: _col,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
              Text(
                '✓ ACKNOWLEDGED',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: C.muted,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
