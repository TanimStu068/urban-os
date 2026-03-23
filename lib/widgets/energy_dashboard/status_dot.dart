import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';

class StatusDot extends StatelessWidget {
  final ZoneStatus status;
  final double blinkT;
  const StatusDot(this.status, this.blinkT, {super.key});
  @override
  Widget build(BuildContext ctx) {
    final pulse = status == ZoneStatus.critical || status == ZoneStatus.warning;
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status.color.withOpacity(pulse ? 0.6 + blinkT * 0.4 : 1),
        boxShadow: [
          BoxShadow(color: status.color.withOpacity(0.5), blurRadius: 5),
        ],
      ),
    );
  }
}
