import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/diff_stat.dart';

typedef C = AppColors;

class AnomalyRow extends StatelessWidget {
  final AnomalyEvent anomaly;
  final double blinkT;
  final VoidCallback onAck;
  const AnomalyRow({
    super.key,
    required this.anomaly,
    required this.blinkT,
    required this.onAck,
  });
  @override
  Widget build(BuildContext ctx) {
    final c = anomaly.severity;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: c.withOpacity(
          anomaly.acknowledged
              ? 0.02
              : 0.06 + (c == C.red ? blinkT * 0.015 : 0),
        ),
        border: Border.all(
          color: c.withOpacity(
            anomaly.acknowledged
                ? 0.1
                : c == C.red
                ? 0.3 + blinkT * 0.1
                : 0.2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: c.withOpacity(0.12),
                  border: Border.all(color: c.withOpacity(0.3)),
                ),
                child: Text(
                  c == C.red
                      ? 'CRITICAL'
                      : c == C.amber
                      ? 'WARNING'
                      : 'INFO',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: c,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                anomaly.id,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.mutedLt,
                ),
              ),
              const Spacer(),
              Text(
                anomaly.time,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            anomaly.description,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9.5,
              fontWeight: anomaly.acknowledged
                  ? FontWeight.normal
                  : FontWeight.w600,
              color: anomaly.acknowledged ? C.mutedLt : C.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              DiffStat(
                'EXPECTED',
                '${(anomaly.expectedKWh / 1000).toStringAsFixed(1)} MWh',
                C.cyan,
              ),
              const SizedBox(width: 14),
              DiffStat(
                'ACTUAL',
                '${(anomaly.actualKWh / 1000).toStringAsFixed(1)} MWh',
                c,
              ),
              const SizedBox(width: 14),
              DiffStat(
                'DEVIATION',
                '+${anomaly.deviation.toStringAsFixed(1)}%',
                c,
              ),
              const Spacer(),
              if (!anomaly.acknowledged)
                GestureDetector(
                  onTap: onAck,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: c.withOpacity(0.1),
                      border: Border.all(color: c.withOpacity(0.3)),
                    ),
                    child: Text(
                      'ACKNOWLEDGE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: c,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                const Text(
                  '✓ ACKNOWLEDGED',
                  style: TextStyle(
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
}
