import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';

typedef C = AppColors;

class ParkingCard extends StatelessWidget {
  final ParkingZone zone;
  final double glowT;
  const ParkingCard({super.key, required this.zone, required this.glowT});

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: C.bgCard.withOpacity(.9),
      border: Border.all(color: zone.color.withOpacity(.18 + glowT * .07)),
      boxShadow: [
        BoxShadow(color: zone.color.withOpacity(.05), blurRadius: 12),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: zone.color.withOpacity(.1),
                border: Border.all(color: zone.color.withOpacity(.3)),
              ),
              child: Icon(
                Icons.local_parking_rounded,
                color: zone.color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: C.white,
                    ),
                  ),
                  Text(
                    zone.id,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 7.5,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${zone.occupied}/${zone.total}',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: zone.color,
                  ),
                ),
                Text(
                  '${(zone.occupancyRate * 100).toStringAsFixed(0)}% FULL',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: zone.color.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(height: 8, color: zone.color.withOpacity(.1)),
              FractionallySizedBox(
                widthFactor: zone.occupancyRate.clamp(0, 1),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [zone.color.withOpacity(.5), zone.color],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: zone.color.withOpacity(.3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${zone.total - zone.occupied} AVAILABLE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: zone.color,
              ),
            ),
            Text(
              'CAP: ${zone.total}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: C.muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
