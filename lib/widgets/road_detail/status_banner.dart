import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';

typedef C = AppColors;

/// A live congestion/road status banner
class StatusBanner extends StatelessWidget {
  final RoadDetailData road;
  final Animation<double> glowT;
  final Animation<double> blinkT;

  const StatusBanner({
    super.key,
    required this.road,
    required this.glowT,
    required this.blinkT,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowT, blinkT]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: road.color.withOpacity(0.06 + glowT.value * 0.03),
          border: Border.all(
            color: road.color.withOpacity(0.3 + blinkT.value * 0.15),
          ),
          boxShadow: [
            BoxShadow(color: road.color.withOpacity(0.08), blurRadius: 16),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: road.color.withOpacity(0.6 + blinkT.value * 0.4),
                boxShadow: [
                  BoxShadow(
                    color: road.color.withOpacity(0.5 * blinkT.value),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '⚠  CONGESTION ALERT — ${road.name} is operating at ${road.congestion}% capacity. '
                'Speed reduced to ${road.speed} km/h (limit: ${road.speedLimit} km/h). '
                '${road.incidents} active incident(s) reported.',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  color: road.color.withOpacity(0.85),
                  letterSpacing: 0.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'LIVE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7,
                letterSpacing: 2,
                color: C.green.withOpacity(0.6 + glowT.value * 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
