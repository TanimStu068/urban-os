import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/environment_dashboard_data_model.dart';
import 'package:urban_os/widgets/environment_dashboard/panel.dart';
import 'package:urban_os/widgets/environment_dashboard/aqi_donut_painter.dart';

class AqiDonutCard extends StatelessWidget {
  final double cityAqi;
  final List<Pollutant> pollutants;
  final AnimationController glowCtrl;
  final AnimationController barAnim;

  const AqiDonutCard({
    super.key,
    required this.cityAqi,
    required this.pollutants,
    required this.glowCtrl,
    required this.barAnim,
  });

  @override
  Widget build(BuildContext context) {
    final lvl = aqiLevel(cityAqi); // Using the aqiLevel function

    return Panel(
      title: 'CITY AQI',
      icon: Icons.air_rounded,
      color: lvl.color,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: AqiDonutPainter(aqi: cityAqi, glow: glowCtrl.value),
                size: const Size(double.infinity, 140),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Pollutant mini bars (first 4)
          ...pollutants
              .take(4)
              .map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([glowCtrl, barAnim]),
                    builder: (_, __) => Row(
                      children: [
                        SizedBox(
                          width: 38,
                          child: Text(
                            p.name,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: p.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.bgCard2,
                                  border: Border.all(color: AppColors.gBdr),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: (p.pct / 200 * barAnim.value)
                                    .clamp(0, 1),
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: p.isOverLimit
                                        ? p.color
                                        : p.color.withOpacity(0.6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: p.color.withOpacity(
                                          0.25 + glowCtrl.value * 0.1,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (p.isOverLimit)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width:
                                        (p.pct / 200 * 100).clamp(0, 100) *
                                        0.01 *
                                        200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: p.color.withOpacity(0.6),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${p.value.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7.5,
                            color: p.isOverLimit ? p.color : AppColors.mutedLt,
                            fontWeight: p.isOverLimit
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          ' ${p.unit}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
