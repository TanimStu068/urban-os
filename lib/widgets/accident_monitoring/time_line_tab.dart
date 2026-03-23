import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/time_line_row.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';

typedef C = AppColors;

class TimelineTab extends StatelessWidget {
  final AccidentEvent accident;
  final double glowT;

  const TimelineTab({super.key, required this.accident, required this.glowT});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'INCIDENT TIMELINE',
      sub: '${accident.timeline.length} events logged  ·  ${accident.id}',
      icon: Icons.timeline_rounded,
      child: Column(
        children: List.generate(accident.timeline.length, (i) {
          final entry = accident.timeline[i];
          final isLast = i == accident.timeline.length - 1;

          return TimelineRow(entry: entry, isLast: isLast, glowT: glowT);
        }),
      ),
    );
  }
}
