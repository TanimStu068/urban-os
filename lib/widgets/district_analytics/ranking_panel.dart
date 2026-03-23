import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_analytics/analysis_section_header.dart';
import 'dart:math';

typedef C = AppColors;

class RankingsPanel extends StatelessWidget {
  final DistrictModel d;
  final DistrictProvider dp;

  const RankingsPanel({super.key, required this.d, required this.dp});

  @override
  Widget build(BuildContext context) {
    final all = dp.districts.toList()
      ..sort((a, b) => b.healthPercentage.compareTo(a.healthPercentage));

    final rank = all.indexWhere((x) => x.id == d.id) + 1;
    final total = all.length;

    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.gBdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisSectionHeader('CITY RANKING', C.amber),
          const SizedBox(height: 12),

          /// 🔥 Rank badge
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: C.amber.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: C.amber.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      color: C.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$rank of $total districts',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: C.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _getRankMessage(rank, total),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: C.mutedLt,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// 📊 Rank progress bar
                    Stack(
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: C.bgCard2,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (total - rank + 1) / total,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  C.amber.withValues(alpha: 0.4),
                                  C.amber,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(height: 1, color: C.gBdr),
          const SizedBox(height: 12),

          /// 🏆 Top 5 leaderboard
          ...all.take(min(5, total)).toList().asMap().entries.map((e) {
            final isThis = e.value.id == d.id;
            final col = isThis ? C.amber : C.mutedLt;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isThis ? C.amber.withValues(alpha: 0.06) : C.bgCard2,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isThis ? C.amber.withValues(alpha: 0.35) : C.gBdr,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '#${e.key + 1}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        color: col,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.value.name,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9.5,
                        color: isThis ? C.white : C.mutedLt,
                      ),
                    ),
                  ),
                  Text(
                    '${e.value.healthPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      color: col,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 🔥 Cleaner logic separation
  String _getRankMessage(int rank, int total) {
    if (rank == 1) return 'Highest health score in the city';
    if (rank <= 3) return 'Top 3 healthiest districts';
    if (rank > total - 3) return 'Needs significant improvement';
    return 'Average performance';
  }
}
