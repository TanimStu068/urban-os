import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';

class EventRow extends StatelessWidget {
  final ParkingEvent event;
  final double glowT;
  const EventRow({super.key, required this.event, required this.glowT});

  @override
  Widget build(BuildContext ctx) {
    final col = event.isEntry ? C.green : C.amber;
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: C.bgCard2.withOpacity(0.5),
        border: Border.all(color: col.withOpacity(0.15 + glowT * 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col.withOpacity(0.1),
              border: Border.all(color: col.withOpacity(0.3)),
            ),
            child: Icon(
              event.isEntry ? Icons.login_rounded : Icons.logout_rounded,
              color: col,
              size: 13,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        event.plate,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Space: ${event.space}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event.time,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: C.mutedLt,
            ),
          ),
        ],
      ),
    );
  }
}
