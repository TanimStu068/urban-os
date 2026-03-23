import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/screens/dashboard/alerts_screen.dart';
import 'package:urban_os/widgets/city_dashboard/alert_row.dart';
import 'package:urban_os/widgets/city_dashboard/section_header.dart';

typedef C = AppColors;

class LiveAlerts extends StatelessWidget {
  final List<AlertLog> alerts;
  final AnimationController blinkCtrl;
  const LiveAlerts({super.key, required this.alerts, required this.blinkCtrl});

  @override
  Widget build(BuildContext context) {
    // Show latest 5 alerts
    final visible = alerts.take(5).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.gBdr),
        color: C.bgCard.withOpacity(.85),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: 'LIVE ALERTS',
            sub: '${alerts.length} active incidents',
            icon: Icons.notifications_active_rounded,
            color: C.red,
            trailing: AnimatedBuilder(
              animation: blinkCtrl,
              builder: (_, __) => Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.red.withOpacity(.4 + blinkCtrl.value * .6),
                  boxShadow: [
                    BoxShadow(
                      color: C.red.withOpacity(.5 * blinkCtrl.value),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No active alerts',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: C.muted,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: C.gBdr),
              itemBuilder: (_, i) => AlertRow(alert: visible[i], index: i),
            ),

          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RealTimeAlertsScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 38,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: C.gBdr),
                color: C.gBg,
              ),
              child: const Center(
                child: Text(
                  'VIEW ALL ALERTS →',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    letterSpacing: 2,
                    color: C.mutedLt,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
