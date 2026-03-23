import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/prediction_data_model.dart';
import 'package:urban_os/widgets/prediction/section_header.dart';
import 'package:urban_os/widgets/prediction/spark_forecast_painter.dart';

typedef C = AppColors;

class ForecastListWidget extends StatefulWidget {
  final List<Prediction> predictions;

  const ForecastListWidget({super.key, required this.predictions});

  @override
  State<ForecastListWidget> createState() => _ForecastListWidgetState();
}

class _ForecastListWidgetState extends State<ForecastListWidget> {
  String? _selectedId;

  String _fmtDuration(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.predictions]
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('FORECAST MODELS', C.cyan),
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
                  color: isSelected ? C.cyan.withOpacity(0.06) : C.bgCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? C.cyan.withOpacity(0.4) : C.gBdr,
                  ),
                ),

                child: Row(
                  children: [
                    /// Spark forecast chart
                    SizedBox(
                      width: 60,
                      height: 36,
                      child: CustomPaint(
                        painter: SparkForecastPainter(
                          p.signalHistory,
                          p.forecastLine,
                          C.cyan,
                          p.level.color,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.sensorId,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: C.white,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            p.summary,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7.5,
                              color: C.mutedLt,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(p.confidence * 100).toInt()}%',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 13,
                            color: p.level.color,
                          ),
                        ),

                        const Text(
                          'CONF',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.mutedLt,
                            letterSpacing: 1,
                          ),
                        ),

                        if (p.expectedAt != null)
                          Text(
                            _fmtDuration(
                              p.expectedAt!.difference(DateTime.now()),
                            ),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.amber,
                            ),
                          ),
                      ],
                    ),
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
