import 'package:flutter/material.dart';
import 'package:urban_os/widgets/consumption_analytics/donut_painter.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';

class BreakdownDonutCard extends StatelessWidget {
  final List<CategoryData> categories;
  final AnimationController glowCtrl;
  final Animation<double> barAnim;

  const BreakdownDonutCard({
    super.key,
    required this.categories,
    required this.glowCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Donut chart
          Expanded(
            flex: 5,
            child: AnimatedBuilder(
              animation: Listenable.merge([glowCtrl, barAnim]),
              builder: (_, __) => CustomPaint(
                painter: DonutPainter(
                  categories: categories,
                  animT: barAnim.value,
                  glowT: glowCtrl.value,
                ),
                size: const Size(double.infinity, 200),
              ),
            ),
          ),

          // Legend
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categories
                    .map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cat.color,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7.5,
                                  color: cat.color,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${cat.pct.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 7.5,
                                color: cat.color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
