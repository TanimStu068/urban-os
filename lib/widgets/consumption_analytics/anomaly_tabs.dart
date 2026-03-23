import 'package:flutter/material.dart';

import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/anomaly_chart_bar.dart';
import 'package:urban_os/widgets/consumption_analytics/anomaly_kpi.dart';
import 'package:urban_os/widgets/consumption_analytics/anomaly_row.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';

typedef C = AppColors;

class AnomaliesTab extends StatelessWidget {
  final List<AnomalyEvent> anomalies; // replace with your Anomaly model
  final int anomalyCount;
  final List<ConsumptionPoint> series; // replace with your chart data type

  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;

  final VoidCallback onAcknowledgeAll;
  final void Function(AnomalyEvent anomaly) onAcknowledgeOne;

  const AnomaliesTab({
    super.key,
    required this.anomalies,
    required this.anomalyCount,
    required this.series,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.onAcknowledgeAll,
    required this.onAcknowledgeOne,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          // ─── SUMMARY KPI ───
          Row(
            children: [
              Expanded(
                child: AnomalyKpi(
                  label: 'CRITICAL',
                  value:
                      '${anomalies.where((a) => a.severity == C.red && !a.acknowledged).length}',
                  color: C.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnomalyKpi(
                  label: 'WARNING',
                  value:
                      '${anomalies.where((a) => a.severity == C.amber && !a.acknowledged).length}',
                  color: C.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnomalyKpi(
                  label: 'INFO',
                  value:
                      '${anomalies.where((a) => a.severity == C.yellow && !a.acknowledged).length}',
                  color: C.yellow,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnomalyKpi(
                  label: 'RESOLVED',
                  value: '${anomalies.where((a) => a.acknowledged).length}',
                  color: C.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ─── ACK ALL ───
          if (anomalyCount > 0) ...[
            GestureDetector(
              onTap: onAcknowledgeAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: C.amber.withOpacity(0.07),
                  border: Border.all(color: C.amber.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all_rounded, color: C.amber, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'ACKNOWLEDGE ALL ANOMALIES',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9.5,
                        color: C.amber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ─── CHART ───
          Panel(
            title: 'DEVIATION CHART',
            icon: Icons.show_chart_rounded,
            color: C.red,
            child: SizedBox(
              height: 120,
              child: AnimatedBuilder(
                animation: Listenable.merge([glowAnimation, blinkAnimation]),
                builder: (_, __) => CustomPaint(
                  painter: AnomalyChartPainter(
                    series: series,
                    glowT: glowAnimation.value,
                    blinkT: blinkAnimation.value,
                  ),
                  size: const Size(double.infinity, 120),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ─── LIST ───
          Panel(
            title: 'ANOMALY LOG',
            icon: Icons.list_alt_rounded,
            color: C.red,
            child: Column(
              children: anomalies.map((a) {
                return AnimatedBuilder(
                  animation: blinkAnimation,
                  builder: (_, __) => AnomalyRow(
                    anomaly: a,
                    blinkT: blinkAnimation.value,
                    onAck: () => onAcknowledgeOne(a),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
