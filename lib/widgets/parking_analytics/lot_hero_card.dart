import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/parking_analytics_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/parking_analytics/tag_chip.dart';
import 'package:urban_os/widgets/parking_analytics/status_chip.dart';
import 'package:urban_os/widgets/parking_analytics/hero_kpi.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class LotHeroCard extends StatelessWidget {
  final ParkingLot lot;
  final int liveOcc;
  final double liveRate;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const LotHeroCard({
    Key? key,
    required this.lot,
    required this.liveOcc,
    required this.liveRate,
    required this.glowCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final col = lot.status.color;

    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.92),
          border: Border.all(
            color: col.withOpacity(0.22 + glowCtrl.value * 0.08),
          ),
          boxShadow: [BoxShadow(color: col.withOpacity(0.07), blurRadius: 20)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: col.withOpacity(0.1),
                border: Border.all(color: col.withOpacity(0.35), width: 2),
              ),
              child: Icon(Icons.local_parking_rounded, color: col, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lot.name,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: C.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      TagChip(lot.id, kAccent),
                      TagChip(lot.type, C.mutedLt),
                      TagChip(lot.district, C.violet),
                      StatusChip(lot.status, blinkCtrl.value),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: HeroKpi('${lot.totalSpaces}', 'TOTAL', kAccent),
                      ),
                      Expanded(child: HeroKpi('$liveOcc', 'OCCUPIED', col)),
                      Expanded(
                        child: HeroKpi(
                          '${lot.totalSpaces - liveOcc - lot.reserved}',
                          'FREE',
                          C.green,
                        ),
                      ),
                      Expanded(
                        child: HeroKpi('${lot.reserved}', 'RESERVED', C.violet),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Big occupancy bar
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: col.withOpacity(0.1),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: liveRate.clamp(0, 1),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [col.withOpacity(0.5), col],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: col.withOpacity(
                                  0.4 + glowCtrl.value * 0.15,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor:
                            ((liveOcc + lot.reserved) / lot.totalSpaces).clamp(
                              0,
                              1,
                            ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: (lot.reserved / lot.totalSpaces * 200).clamp(
                              4,
                              60,
                            ),
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(5),
                              ),
                              color: C.violet.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${(liveRate * 100).toStringAsFixed(1)}% occupied',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: col.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: C.violet.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lot.reserved} reserved',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.mutedLt,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳${lot.pricePerHour.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: C.teal,
                  ),
                ),
                const Text(
                  '/hr',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
