import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';

class IncidentCard extends StatelessWidget {
  final CCTVIncident incident;

  const IncidentCard({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: incident.severityColor.withOpacity(0.08),
        border: Border.all(color: incident.severityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: incident.severityColor, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident.description,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: C.white,
                  ),
                ),
                Text(
                  incident.timeAgo,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: incident.severityColor.withOpacity(0.2),
            ),
            child: Text(
              incident.severity,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 6,
                color: incident.severityColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
