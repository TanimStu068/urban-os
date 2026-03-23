import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/area_sparking.dart';
import 'package:urban_os/widgets/consumption_analytics/detail_stat.dart';
import 'package:urban_os/widgets/consumption_analytics/mini_matrict.dart';
import 'package:urban_os/widgets/consumption_analytics/sec_label.dart';

typedef C = AppColors;

class DistrictCard extends StatelessWidget {
  final DistrictConsumption d;
  final bool isSelected;
  final VoidCallback onTap;

  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final Animation<double> barAnim;

  const DistrictCard({
    super.key,
    required this.d,
    required this.isSelected,
    required this.onTap,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([glowCtrl, blinkCtrl]),
        builder: (_, __) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected
                  ? d.color.withOpacity(0.08)
                  : C.bgCard.withOpacity(0.9),
              border: Border.all(
                color: isSelected ? d.color.withOpacity(0.4) : C.gBdr,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: d.color.withOpacity(0.1 + glowCtrl.value * 0.04),
                        blurRadius: 14,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildMetrics(),
                const SizedBox(height: 8),
                _buildLoadBar(),
                if (isSelected) ..._buildExpandedSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: d.color.withOpacity(0.12),
            border: Border.all(color: d.color.withOpacity(0.35)),
          ),
          child: Icon(Icons.location_city_rounded, color: d.color, size: 16),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.name,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: d.color,
                ),
              ),
              Text(
                '${d.id}  ·  ${d.pct.toStringAsFixed(1)}% of total',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
        ),

        _buildChangeBadge(),

        const SizedBox(width: 8),

        Icon(
          isSelected ? Icons.expand_less_rounded : Icons.expand_more_rounded,
          color: C.mutedLt,
          size: 16,
        ),
      ],
    );
  }

  Widget _buildChangeBadge() {
    final isUp = d.change > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (isUp ? C.red : C.green).withOpacity(0.1),
        border: Border.all(color: (isUp ? C.red : C.green).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isUp ? C.red : C.green,
            size: 10,
          ),
          const SizedBox(width: 3),
          Text(
            '${d.change.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: isUp ? C.red : C.green,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- METRICS ----------------
  Widget _buildMetrics() {
    return Row(
      children: [
        MiniMetric(
          'TOTAL',
          '${(d.total / 1000).toStringAsFixed(1)} MWh',
          d.color,
        ),
        MiniMetric(
          'AVG',
          '${(d.avgLoad / 1000).toStringAsFixed(2)} MW',
          C.cyan,
        ),
        MiniMetric(
          'PEAK',
          '${(d.peakLoad / 1000).toStringAsFixed(2)} MW',
          C.red,
        ),
        MiniMetric('COST', '\$${d.cost.toStringAsFixed(0)}', C.green),
      ],
    );
  }

  /// ---------------- LOAD BAR ----------------
  Widget _buildLoadBar() {
    return Stack(
      children: [
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: C.bgCard2,
            border: Border.all(color: C.gBdr),
          ),
        ),
        AnimatedBuilder(
          animation: barAnim,
          builder: (_, __) => FractionallySizedBox(
            widthFactor: d.pct / 100 * barAnim.value,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [d.color.withOpacity(0.55), d.color],
                ),
                boxShadow: [
                  BoxShadow(
                    color: d.color.withOpacity(0.25 + glowCtrl.value * 0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '${d.pct.toStringAsFixed(1)}%  OF TOTAL  ·  ${(d.total / 1000).toStringAsFixed(1)} MWh',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- EXPANDED ----------------
  List<Widget> _buildExpandedSection() {
    return [
      const SizedBox(height: 10),
      const Divider(color: Color(0x1AFFAA00), height: 1),
      const SizedBox(height: 8),
      SecLabel('HOURLY PATTERN (12H)'),
      const SizedBox(height: 5),
      SizedBox(
        height: 48,
        child: AnimatedBuilder(
          animation: glowCtrl,
          builder: (_, __) => CustomPaint(
            painter: AreaSparkPainter(
              data: d.sparkline,
              color: d.color,
              glowT: glowCtrl.value,
            ),
            size: const Size(double.infinity, 48),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DetailStat(
            'LOAD FACTOR',
            '${(d.avgLoad / d.peakLoad * 100).toStringAsFixed(0)}%',
            d.color,
          ),
          DetailStat(
            'PEAK/AVG',
            '${(d.peakLoad / d.avgLoad).toStringAsFixed(2)}×',
            C.red,
          ),
          DetailStat(
            'COST/MWH',
            '\$${(d.cost / (d.total / 1000)).toStringAsFixed(1)}',
            C.green,
          ),
          DetailStat('SHARE', '${d.pct.toStringAsFixed(1)}%', C.amber),
        ],
      ),
    ];
  }
}
