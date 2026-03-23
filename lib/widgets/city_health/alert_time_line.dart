import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_health_data_model.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/widgets/city_health/card.dart';
import 'package:urban_os/widgets/city_health/card_header_simple.dart';
import 'package:urban_os/widgets/city_health/empty_state.dart';

typedef C = AppColors;

class AlertTimeline extends StatelessWidget {
  final List<AlertLog> alerts;
  final List events;
  final AnimationController alertCtrl;
  const AlertTimeline({
    super.key,
    required this.alerts,
    required this.events,
    required this.alertCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...alerts]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final recent = sorted.take(6).toList();

    return CardWidget(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CardHeaderSimple(
                  title: 'ALERT TIMELINE (${alerts.length})',
                  icon: Icons.notifications_active_rounded,
                  color: C.red,
                ),
              ),
              if (alerts.any((a) => a.isActive))
                AnimatedBuilder(
                  animation: alertCtrl,
                  builder: (_, __) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.red.withOpacity(.4 + alertCtrl.value * .6),
                      boxShadow: [
                        BoxShadow(
                          color: C.red.withOpacity(.4 * alertCtrl.value),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          if (recent.isEmpty)
            EmptyState(icon: Icons.check_rounded, message: 'No alerts recorded')
          else
            ...List.generate(recent.length, (i) {
              final a = recent[i];
              final col = a.sColor;
              final isLast = i == recent.length - 1;
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        AnimatedBuilder(
                          animation: alertCtrl,
                          builder: (_, __) => Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: a.isActive
                                  ? col.withOpacity(.4 + alertCtrl.value * .4)
                                  : col.withOpacity(.3),
                              border: Border.all(
                                color: col.withOpacity(.6),
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(child: Container(width: 1, color: C.gBdr)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: col.withOpacity(.04),
                          border: Border.all(color: col.withOpacity(.15)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.title,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 9,
                                      color: col,
                                    ),
                                  ),
                                  Text(
                                    a.description,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 7,
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
                                  a.ageLabel,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    color: col,
                                  ),
                                ),
                                Text(
                                  a.isActive ? 'ACTIVE' : 'RESOLVED',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 6,
                                    color: a.isActive ? col : C.muted,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
