import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/parking_analytics/vdiv.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class SummaryStrip extends StatelessWidget {
  final int totalSpaces;
  final int totalOccupied;
  final int totalAvailable;
  final double totalOccupancyRate; // 0.0 to 1.0
  final double totalRevenue; // 7-day revenue
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;

  const SummaryStrip({
    Key? key,
    required this.totalSpaces,
    required this.totalOccupied,
    required this.totalAvailable,
    required this.totalOccupancyRate,
    required this.totalRevenue,
    required this.glowCtrl,
    required this.blinkCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowCtrl, blinkCtrl]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: C.bgCard.withOpacity(0.88),
          border: Border.all(
            color: kAccent.withOpacity(0.15 + glowCtrl.value * 0.06),
          ),
          boxShadow: [
            BoxShadow(color: kAccent.withOpacity(0.04), blurRadius: 18),
          ],
        ),
        child: Row(
          children: [
            _SummaryKpi(
              '$totalSpaces',
              'TOTAL SPACES',
              kAccent,
              Icons.local_parking_rounded,
            ),
            VDiv(),
            _SummaryKpi(
              '$totalOccupied',
              'OCCUPIED',
              C.amber,
              Icons.directions_car_rounded,
            ),
            VDiv(),
            _SummaryKpi(
              '$totalAvailable',
              'AVAILABLE',
              C.green,
              Icons.check_circle_outline_rounded,
            ),
            VDiv(),
            _SummaryKpi(
              '${(totalOccupancyRate * 100).toStringAsFixed(0)}%',
              'OCCUPANCY',
              totalOccupancyRate > 0.8 ? C.red : C.amber,
              Icons.donut_large_rounded,
            ),
            VDiv(),
            _SummaryKpi(
              '৳${(totalRevenue / 1000).toStringAsFixed(1)}k',
              '7D REVENUE',
              C.teal,
              Icons.attach_money_rounded,
            ),
            VDiv(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: C.green.withOpacity(0.1),
                    border: Border.all(color: C.green.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.sensors_rounded,
                    color: C.green.withOpacity(0.7 + glowCtrl.value * 0.3),
                    size: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'LIVE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    letterSpacing: 2,
                    color: C.green.withOpacity(0.7 + glowCtrl.value * 0.2),
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

/// KPI Item
class _SummaryKpi extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _SummaryKpi(this.value, this.label, this.color, this.icon, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 7,
            color: C.muted,
          ),
        ),
      ],
    );
  }
}
