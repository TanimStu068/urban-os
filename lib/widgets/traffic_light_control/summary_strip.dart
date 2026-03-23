import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_light_control_data_model.dart';
import 'package:urban_os/widgets/traffic_light_control/v_divider.dart';
import 'package:urban_os/widgets/traffic_light_control/summary_kpi.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class SummaryStrip extends StatelessWidget {
  final List<Intersection> intersections;
  final Animation<double> glowCtrl;
  final Animation<double> blinkCtrl;

  const SummaryStrip({
    super.key,
    required this.intersections,
    required this.glowCtrl,
    required this.blinkCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) {
        final greens = intersections
            .where((i) => i.phase == SignalPhase.green)
            .length;
        final yellows = intersections
            .where((i) => i.phase == SignalPhase.yellow)
            .length;
        final reds = intersections
            .where((i) => i.phase == SignalPhase.red)
            .length;
        final adaptive = intersections.where((i) => i.isAdaptive).length;

        return Container(
          margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: C.bgCard.withOpacity(0.88),
            border: Border.all(
              color: kAccent.withOpacity(0.15 + glowCtrl.value * 0.06),
            ),
            boxShadow: [
              BoxShadow(color: kAccent.withOpacity(0.05), blurRadius: 18),
            ],
          ),
          child: Row(
            children: [
              SummaryKpi(
                '${intersections.length}',
                'TOTAL',
                kAccent,
                Icons.traffic_rounded,
                glowCtrl.value,
              ),
              VDivider(),
              SummaryKpi(
                '$greens',
                'GREEN',
                C.green,
                Icons.circle,
                glowCtrl.value,
              ),
              VDivider(),
              SummaryKpi(
                '$yellows',
                'YELLOW',
                C.amber,
                Icons.circle,
                glowCtrl.value,
              ),
              VDivider(),
              SummaryKpi('$reds', 'RED', C.red, Icons.circle, glowCtrl.value),
              VDivider(),
              SummaryKpi(
                '$adaptive',
                'ADPT',
                C.teal,
                Icons.auto_awesome_rounded,
                glowCtrl.value,
              ),
              VDivider(),
              // Live indicator
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.green.withOpacity(0.1),
                      border: Border.all(color: C.green.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.sensors_rounded,
                      color: C.green.withOpacity(0.7 + glowCtrl.value * 0.3),
                      size: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      letterSpacing: 2,
                      color: C.green.withOpacity(0.6 + glowCtrl.value * 0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
