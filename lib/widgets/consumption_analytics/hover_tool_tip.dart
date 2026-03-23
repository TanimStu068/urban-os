import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

class HoverTooltip extends StatelessWidget {
  final ConsumptionPoint point;
  final int index;
  final String xLabel;
  final bool compareEnabled;
  final bool showForecast;

  const HoverTooltip({
    super.key,
    required this.point,
    required this.index,
    required this.xLabel,
    this.compareEnabled = false,
    this.showForecast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: C.bgCard2,
        border: Border.all(color: C.amber.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TTCell('INDEX', xLabel, C.mutedLt),
          _TTCell(
            'VALUE',
            '${(point.value / 1000).toStringAsFixed(2)} MWh',
            C.amber,
          ),
          if (compareEnabled)
            _TTCell(
              'PREV',
              '${(point.prevValue / 1000).toStringAsFixed(2)} MWh',
              C.cyan,
            ),
          if (showForecast)
            _TTCell(
              'FORECAST',
              '${(point.forecast / 1000).toStringAsFixed(2)} MWh',
              C.violet,
            ),
          _TTCell('COST', '\$${point.cost.toStringAsFixed(0)}', C.green),
          if (point.isAnomaly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: C.red.withOpacity(0.15),
                border: Border.all(color: C.red.withOpacity(0.4)),
              ),
              child: const Text(
                'ANOMALY',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _TTCell(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 6.5,
            color: C.mutedLt,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 7.5,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
