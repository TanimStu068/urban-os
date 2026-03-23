import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';

typedef C = AppColors;

class TimelineCard extends StatelessWidget {
  final DistrictModel d;
  final List<dynamic> Function(DistrictModel) timelineGenerator;

  const TimelineCard({
    super.key,
    required this.d,
    required this.timelineGenerator,
  });

  @override
  Widget build(BuildContext context) {
    final events = timelineGenerator(d);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        children: events.asMap().entries.map((e) {
          final ev = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dot + line
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ev.$3,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ev.$3.withOpacity(0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    if (e.key < events.length - 1)
                      Container(width: 1, height: 28, color: C.gBdr),
                  ],
                ),

                const SizedBox(width: 10),

                // Event title + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev.$1,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: ev.$3,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        ev.$2,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          color: C.mutedLt,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Event timestamp
                Text(
                  ev.$4,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
