import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/city_health/arc_painter.dart';
import 'package:urban_os/widgets/city_health/dtag.dart';
import 'package:urban_os/widgets/city_health/track_painter.dart';

typedef C = AppColors;

class DistrictDetail extends StatelessWidget {
  final DistrictModel district;
  final AnimationController pulseCtrl, glowCtrl;
  const DistrictDetail({
    super.key,
    required this.district,
    required this.pulseCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final col = district.typeColor;
    final hc = district.healthColor;
    final h = district.healthScore;
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: col.withOpacity(.05),
          border: Border.all(
            color: col.withOpacity(.15 + glowCtrl.value * .07),
          ),
        ),
        child: Row(
          children: [
            // Health mini ring
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Container(
                      width: 55 + pulseCtrl.value * 5,
                      height: 55 + pulseCtrl.value * 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: hc.withOpacity((1 - pulseCtrl.value) * .2),
                          width: .8,
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: TrackPainter(hc.withOpacity(.15), 52, 5),
                    size: const Size(60, 60),
                  ),
                  CustomPaint(
                    painter: ArcPainter(h / 100, hc, 52, 5, 0),
                    size: const Size(60, 60),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${h.toInt()}',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: hc,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          color: hc.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(district.typeIcon, color: col, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        district.name,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: col,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    district.type.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7,
                      letterSpacing: 2,
                      color: col.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      DTag(label: 'POP ${district.population}', color: C.cyan),
                      const SizedBox(width: 6),
                      DTag(
                        label: 'INC ${district.incidentCount}',
                        color: district.incidentCount > 0 ? C.red : C.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
