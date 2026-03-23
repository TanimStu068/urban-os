import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';

typedef C = AppColors;

class AlertRow extends StatelessWidget {
  final EnergyAlert alert;
  final double blinkT;
  final VoidCallback onAck;

  const AlertRow({
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

  @override
  Widget build(BuildContext ctx) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: _col.withOpacity(alert.acknowledged ? 0.02 : 0.06),
      border: Border.all(
        color: _col.withOpacity(
          alert.acknowledged
              ? 0.1
              : alert.level == AlertLevel.critical
              ? 0.3 + blinkT * 0.12
              : 0.2,
        ),
      ),
    ),
    child: Row(
      children: [
        Icon(
          alert.level == AlertLevel.critical
              ? Icons.error_rounded
              : alert.level == AlertLevel.warning
              ? Icons.warning_amber_rounded
              : Icons.info_outline_rounded,
          color: _col.withOpacity(alert.acknowledged ? 0.4 : 1),
          size: 13,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.message,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8.5,
                  color: alert.acknowledged ? C.muted : C.white,
                  fontWeight: alert.acknowledged
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
              Text(
                '${alert.zone}  ·  ${alert.time}',
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
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _col.withOpacity(0.1),
                border: Border.all(color: _col.withOpacity(0.3)),
              ),
              child: Icon(Icons.check_rounded, color: _col, size: 10),
            ),
          )
        else
          Icon(
            Icons.check_circle_outline_rounded,
            color: C.muted.withOpacity(0.5),
            size: 12,
          ),
      ],
    ),
  );
}
