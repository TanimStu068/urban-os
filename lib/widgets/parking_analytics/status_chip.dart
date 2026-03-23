import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';

class StatusChip extends StatelessWidget {
  final ParkingStatus status;
  final double blinkT;
  final bool compact;
  const StatusChip(this.status, this.blinkT, {this.compact = false});

  @override
  Widget build(BuildContext ctx) {
    final col = status.color;
    final isPulsing =
        status == ParkingStatus.full || status == ParkingStatus.filling;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 7,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: col.withOpacity(isPulsing ? 0.1 + blinkT * 0.04 : 0.08),
        border: Border.all(
          color: col.withOpacity(isPulsing ? 0.4 + blinkT * 0.15 : 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPulsing) ...[
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
              fontSize: compact ? 6.5 : 7.5,
              letterSpacing: 0.8,
              color: col,
            ),
          ),
        ],
      ),
    );
  }
}
