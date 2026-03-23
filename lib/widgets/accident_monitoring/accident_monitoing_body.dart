import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'incident_list_tile.dart';

class AccidentMonitoringBody extends StatelessWidget {
  final List<AccidentEvent> accidents;
  final List<AccidentEvent> filtered;
  final int selectedIdx;
  final double glowValue;
  final double blinkValue;

  // Callbacks
  final void Function(int newIndex) onSelectIncident;
  final Widget Function() buildDetailPanel;

  const AccidentMonitoringBody({
    Key? key,
    required this.accidents,
    required this.filtered,
    required this.selectedIdx,
    required this.glowValue,
    required this.blinkValue,
    required this.onSelectIncident,
    required this.buildDetailPanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT: incident list
        SizedBox(
          width: 200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 40),
            physics: const BouncingScrollPhysics(),
            children: filtered.map((acc) {
              final gi = accidents.indexOf(acc);
              return IncidentListTile(
                accident: acc,
                isSelected: gi == selectedIdx,
                glowT: glowValue,
                blinkT: blinkValue,
                onTap: () => onSelectIncident(gi),
              );
            }).toList(),
          ),
        ),

        // RIGHT: detail panel
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(6, 10, 14, 40),
            physics: const BouncingScrollPhysics(),
            children: [buildDetailPanel()],
          ),
        ),
      ],
    );
  }
}
