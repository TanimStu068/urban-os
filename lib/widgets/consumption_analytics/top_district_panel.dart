import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/consumption_analytics/panel.dart';

typedef C = AppColors;

class TopDistrictsPanel extends StatelessWidget {
  final List<DistrictConsumption> districts;
  final Animation<double> barAnim;

  const TopDistrictsPanel({
    super.key,
    required this.districts,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'TOP CONSUMERS',
      icon: Icons.bar_chart_rounded,
      color: C.cyan,
      child: Column(
        children: districts.take(5).map((d) {
          final pct = d.pct / districts.first.pct * 100;

          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text(
                    d.name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: d.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: barAnim,
                    builder: (_, __) => Stack(
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: C.bgCard2,
                            border: Border.all(color: C.gBdr),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: pct / 100 * barAnim.value,
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [d.color.withOpacity(0.5), d.color],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: d.color.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '${d.pct.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: d.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
