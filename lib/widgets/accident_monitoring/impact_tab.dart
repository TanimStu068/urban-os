import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/ai_recommend_row.dart';
import 'package:urban_os/widgets/accident_monitoring/card.dart';
import 'package:urban_os/widgets/accident_monitoring/congestion_impact.dart';
import 'package:urban_os/widgets/accident_monitoring/impact_radar_painter.dart';

typedef C = AppColors;

class ImpactTab extends StatelessWidget {
  final AccidentEvent accident;
  final double radarT;
  final double glowT;

  const ImpactTab({
    super.key,
    required this.accident,
    required this.radarT,
    required this.glowT,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardWidget(
          title: 'IMPACT RADAR',
          sub: 'Multi-axis severity assessment',
          icon: Icons.radar_rounded,
          child: SizedBox(
            height: 220,
            child: CustomPaint(
              painter: ImpactRadarPainter(
                values: accident.impactRadarValues,
                color: accident.severity.color,
                t: radarT,
                glowT: glowT,
              ),
              size: Size.infinite,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ── Congestion Impact ──
        CardWidget(
          title: 'CONGESTION IMPACT',
          sub: 'Road network cascade effect',
          icon: Icons.traffic_rounded,
          child: Column(
            children: [
              CongestionImpactRow('Ring Road 4', 88, '+24%', C.red, glowT),
              CongestionImpactRow('North Access', 91, '+18%', C.red, glowT),
              CongestionImpactRow('Industrial Blvd', 72, '+8%', C.amber, glowT),
              CongestionImpactRow('Freight F1', 61, '+3%', C.amber, glowT),
              CongestionImpactRow('Gate Road', 35, '0%', C.green, glowT),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── AI Recommendations ──
        CardWidget(
          title: 'AI RECOMMENDATIONS',
          sub: 'System-generated response actions',
          icon: Icons.auto_fix_high_rounded,
          child: Column(
            children: const [
              AiRecommendRow(
                'Extend emergency vehicle corridor on Ring Rd 4 — close lane 3&4 inbound',
                Icons.emergency_rounded,
                C.red,
                'URGENT',
              ),
              AiRecommendRow(
                'Activate dynamic rerouting via South Bypass for civilian traffic',
                Icons.alt_route_rounded,
                C.teal, // replace kAccent if not globally available
                'ACTION',
              ),
              AiRecommendRow(
                'Notify freight depot of extended ETA — 35 min delay projected',
                Icons.local_shipping_rounded,
                C.amber,
                'NOTIFY',
              ),
              AiRecommendRow(
                'Adjust TL-01 & TL-06 to emergency signal mode — clear response corridor',
                Icons.traffic_rounded,
                C.teal,
                'ACTION',
              ),
              AiRecommendRow(
                'Hospital BD-MED-01 pre-alerted for 2 incoming casualties',
                Icons.local_hospital_rounded,
                C.orange,
                'ACTIVE',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
