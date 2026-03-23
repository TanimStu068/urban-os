import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/widgets/city_health/empty_state.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header.dart';

typedef C = AppColors;

class AlertsPanel extends StatelessWidget {
  final List<AlertLog> alerts;
  final AnimationController alertCtrl;
  const AlertsPanel({super.key, required this.alerts, required this.alertCtrl});

  @override
  Widget build(BuildContext context) {
    final active = alerts.where((a) => a.isActive).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: 'ACTIVE ALERTS (${active.length})',
            icon: Icons.warning_amber_rounded,
            color: C.red,
          ),
          if (active.isEmpty)
            EmptyState(
              icon: Icons.check_circle_rounded,
              message: 'All systems nominal',
            )
          else
            ...active.take(8).map((a) {
              final col = a.sColor;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: col.withOpacity(.05),
                  border: Border.all(color: col.withOpacity(.2)),
                ),
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: alertCtrl,
                      builder: (_, __) => Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: col.withOpacity(.5 + alertCtrl.value * .5),
                          boxShadow: [
                            BoxShadow(
                              color: col.withOpacity(.4 * alertCtrl.value),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: col,
                            ),
                          ),
                          Text(
                            a.description,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: C.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          a.severity.name.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: col,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          a.ageLabel,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
