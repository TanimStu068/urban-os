import 'package:flutter/material.dart';
import 'package:urban_os/widgets/city_alerts/divider.dart';
import 'package:urban_os/widgets/city_alerts/stat_bubble.dart';

class AlertStatSummary extends StatelessWidget {
  final int critical, warning, info, resolved;
  final AnimationController blinkCtrl, pulseCtrl;
  const AlertStatSummary({
    super.key,
    required this.critical,
    required this.warning,
    required this.info,
    required this.resolved,
    required this.blinkCtrl,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: C.bgCard.withOpacity(.85),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatBubble(
              value: critical,
              label: 'CRITICAL',
              color: C.red,
              blinkCtrl: blinkCtrl,
              doBlink: critical > 0,
            ),
          ),
          DividerWidget(),
          Expanded(
            child: StatBubble(
              value: warning,
              label: 'WARNING',
              color: C.amber,
              blinkCtrl: blinkCtrl,
              doBlink: false,
            ),
          ),
          DividerWidget(),
          Expanded(
            child: StatBubble(
              value: info,
              label: 'INFO',
              color: C.cyan,
              blinkCtrl: blinkCtrl,
              doBlink: false,
            ),
          ),
          DividerWidget(),
          Expanded(
            child: StatBubble(
              value: resolved,
              label: 'RESOLVED',
              color: C.green,
              blinkCtrl: blinkCtrl,
              doBlink: false,
            ),
          ),
        ],
      ),
    );
  }
}
