import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/hotspot_row.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/accident_monitoring/severity_donut_painter.dart';
import 'package:urban_os/widgets/accident_monitoring/city_map_painter.dart';

typedef C = AppColors;

class OverviewTab extends StatelessWidget {
  final AccidentEvent accident;
  final List<AccidentEvent> accidents;
  final double waveT;
  final double pulseT;
  final double glowT;

  const OverviewTab({
    super.key,
    required this.accident,
    required this.accidents,
    required this.waveT,
    required this.pulseT,
    required this.glowT,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Incident Map ──
        CardWidget(
          title: 'INCIDENT MAP',
          sub: 'All active incidents — city overview',
          icon: Icons.map_rounded,
          child: SizedBox(
            height: 200,
            child: CustomPaint(
              painter: CityMapPainter(
                accidents: accidents, // ✅ use passed param
                selectedId: accident.id, // ✅ current selected accident
                waveT: waveT, // ✅ use passed value
                pulseT: pulseT,
                glowT: glowT,
              ),
              size: Size.infinite,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Severity Distribution ──
        CardWidget(
          title: 'SEVERITY DISTRIBUTION',
          sub: 'Today\'s incident breakdown',
          icon: Icons.donut_large_rounded,
          child: SizedBox(
            height: 130,
            child: CustomPaint(
              painter: SeverityDonutPainter(accidents: accidents, glowT: glowT),
              size: Size.infinite,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Hotspot Analysis ──
        CardWidget(
          title: 'HOTSPOT ANALYSIS',
          sub: 'Roads ranked by incident frequency',
          icon: Icons.local_fire_department_rounded,
          child: Column(
            children: [
              HotspotRow('Ring Road 4', 3, C.red, glowT),
              HotspotRow('North Access', 2, C.orange, glowT),
              HotspotRow('Industrial Blvd', 1, C.amber, glowT),
              HotspotRow('Freight Route F1', 1, C.teal, glowT),
              HotspotRow('South Bypass', 1, C.green, glowT),
            ],
          ),
        ),
      ],
    );
  }
}
