import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/donut_painter.dart';
import 'package:urban_os/widgets/rule_builder/panel.dart';

typedef C = AppColors;

class CategoriesTab extends StatelessWidget {
  final List<CategoryData> categories;
  final AnimationController glowCtrl;
  final Animation<double> barAnim;

  const CategoriesTab({
    super.key,
    required this.categories,
    required this.glowCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          Panel(
            title: 'CONSUMPTION BY CATEGORY',
            icon: Icons.donut_large_rounded,
            color: C.yellow,
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([glowCtrl, barAnim]),
                    builder: (_, __) => CustomPaint(
                      painter: DonutPainter(
                        categories: categories,
                        animT: barAnim.value,
                        glowT: glowCtrl.value,
                      ),
                      size: const Size(double.infinity, 180),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// Category List
                ...categories.map(
                  (cat) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: cat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cat.name,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: C.mutedLt,
                            ),
                          ),
                        ),
                        Text(
                          '${cat.pct.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
