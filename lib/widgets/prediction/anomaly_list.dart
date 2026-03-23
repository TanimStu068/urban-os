import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/meta_badge.dart';
import 'package:urban_os/widgets/prediction/section_header.dart';

typedef C = AppColors;

class AnomalyListWidget extends StatefulWidget {
  final List<Prediction> predictions;

  const AnomalyListWidget({super.key, required this.predictions});

  @override
  State<AnomalyListWidget> createState() => _AnomalyListWidgetState();
}

class _AnomalyListWidgetState extends State<AnomalyListWidget> {
  String? _selectedId;

  String _fmtDuration(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.predictions]
      ..sort((a, b) => b.anomalyScore.compareTo(a.anomalyScore));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('ANOMALY DETECTIONS', C.red),
          const SizedBox(height: 10),

          ...sorted.map((p) {
            final isSelected = _selectedId == p.id;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedId = isSelected ? null : p.id;
                });
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: isSelected
                      ? p.level.color.withOpacity(0.08)
                      : C.bgCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? p.level.color.withOpacity(0.5) : C.gBdr,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: p.level.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: p.level.color.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            p.level.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: p.level.color,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          p.sensorId,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: C.cyan,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '· ${p.district}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: C.mutedLt,
                          ),
                        ),

                        const Spacer(),

                        /// anomaly bar
                        SizedBox(
                          width: 60,
                          child: Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: C.gBdr,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              FractionallySizedBox(
                                widthFactor: p.anomalyScore,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: p.level.color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '${(p.anomalyScore * 100).toInt()}%',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 9,
                            color: p.level.color,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Icon(
                          isSelected
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: C.mutedLt,
                          size: 14,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      p.summary,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        color: C.white,
                      ),
                    ),

                    if (isSelected) ...[
                      const SizedBox(height: 8),
                      Container(height: 1, color: C.gBdr),
                      const SizedBox(height: 8),

                      Text(
                        p.detail,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.mutedLt,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          MetaBadge(
                            'CONF ${(p.confidence * 100).toInt()}%',
                            C.cyan,
                          ),

                          const SizedBox(width: 6),

                          MetaBadge(
                            'SCORE ${(p.anomalyScore * 100).toInt()}',
                            p.level.color,
                          ),

                          const SizedBox(width: 6),

                          if (p.expectedAt != null)
                            MetaBadge(
                              'ETA ${_fmtDuration(p.expectedAt!.difference(DateTime.now()))}',
                              C.amber,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
