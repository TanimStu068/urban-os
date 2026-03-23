import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/widgets/city_dashboard/city_map_painter.dart';
import 'package:urban_os/widgets/city_dashboard/live_chip.dart';
import 'package:urban_os/widgets/city_dashboard/section_header.dart';

typedef C = AppColors;

class CityMapSection extends StatelessWidget {
  final AnimationController mapCtrl, pulseCtrl, glowCtrl;
  final List<DistrictModel> districts;
  final int sensorCount, alertCount, ruleCount;
  const CityMapSection({
    super.key,
    required this.mapCtrl,
    required this.pulseCtrl,
    required this.glowCtrl,
    required this.districts,
    required this.sensorCount,
    required this.alertCount,
    required this.ruleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.gBdr),
        color: C.bgCard.withOpacity(.85),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: 'CITY MAP',
            sub: 'Live district overview',
            icon: Icons.map_rounded,
            color: C.cyan,
            trailing: const LiveChip(),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: SizedBox(
              height: 220,
              child: AnimatedBuilder(
                animation: Listenable.merge([mapCtrl, pulseCtrl, glowCtrl]),
                builder: (_, __) => CustomPaint(
                  painter: CityMapPainter(
                    mapT: mapCtrl.value,
                    pulseT: pulseCtrl.value,
                    glowT: glowCtrl.value,
                    districts: districts,
                    sensorCount: sensorCount,
                    alertCount: alertCount,
                    ruleCount: ruleCount,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
