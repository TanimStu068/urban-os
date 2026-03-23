import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/power_grid_data_model.dart';

class StatusBadge extends StatelessWidget {
  final ZoneStatus status;
  final double blinkT;
  const StatusBadge(this.status, this.blinkT, {super.key});
  @override
  Widget build(BuildContext ctx) {
    final pulse = status == ZoneStatus.critical || status == ZoneStatus.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: status.color.withOpacity(pulse ? 0.1 + blinkT * 0.04 : 0.07),
        border: Border.all(
          color: status.color.withOpacity(pulse ? 0.35 + blinkT * 0.1 : 0.25),
        ),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 7,
          color: status.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
