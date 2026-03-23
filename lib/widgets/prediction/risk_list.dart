import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/section_header.dart';

typedef C = AppColors;

class RiskListWidget extends StatelessWidget {
  final List<RiskZone> riskZones;

  const RiskListWidget({super.key, required this.riskZones});

  @override
  Widget build(BuildContext context) {
    final sorted = [...riskZones]..sort((a, b) => b.score.compareTo(a.score));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('ZONE RISK INDEX', C.amber),
          const SizedBox(height: 10),

          ...sorted.map((z) {
            final col = z.score > 0.8
                ? C.red
                : z.score > 0.55
                ? C.amber
                : C.green;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: C.bgCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: col.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: col.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: col.withOpacity(0.35)),
                    ),
                    child: Center(
                      child: Text(
                        z.district.substring(0, 2),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: col,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          z.district,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: C.white,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          z.topThreat,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7.5,
                            color: C.mutedLt,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Stack(
                          children: [
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: C.bgCard2,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            FractionallySizedBox(
                              widthFactor: z.score,
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(z.score * 100).toInt()}',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          color: col,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '${z.alertCount} ALERTS',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.mutedLt,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
