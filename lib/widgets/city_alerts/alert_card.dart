import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';
import 'package:urban_os/widgets/city_alerts/expanded_detail.dart';
import 'package:urban_os/widgets/city_alerts/severity_icon.dart';

typedef C = AppColors;

class AlertCard extends StatelessWidget {
  final UIAlert uiAlert;
  final int index;
  final AnimationController blinkCtrl, glowCtrl;
  final VoidCallback onAcknowledge, onDismiss, onExpand;

  const AlertCard({
    super.key,
    required this.uiAlert,
    required this.index,
    required this.blinkCtrl,
    required this.glowCtrl,
    required this.onAcknowledge,
    required this.onDismiss,
    required this.onExpand,
  });

  String _formatTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final alert = uiAlert.alert;
    final uiSev = mapAlertSeverity(alert.severity, alert.isActive);
    final color = uiSev.color;
    final isCrit = uiSev == UISeverity.critical && alert.isActive;

    return AnimatedBuilder(
      animation: Listenable.merge([blinkCtrl, glowCtrl]),
      builder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(.9),
          border: Border.all(
            color: isCrit
                ? color.withOpacity(.3 + blinkCtrl.value * .25)
                : !alert.isActive
                ? C.gBdr.withOpacity(.5)
                : color.withOpacity(.2),
            width: isCrit ? 1.2 : 1,
          ),
          boxShadow: isCrit
              ? [
                  BoxShadow(
                    color: color.withOpacity(.12 + blinkCtrl.value * .08),
                    blurRadius: 20,
                  ),
                ]
              : !alert.isActive
              ? []
              : [BoxShadow(color: color.withOpacity(.06), blurRadius: 12)],
        ),
        child: Column(
          children: [
            // ── CARD MAIN ROW ──
            GestureDetector(
              onTap: onExpand,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Severity icon
                    SeverityIcon(
                      sev: uiSev,
                      acked: !alert.isActive,
                      blinkCtrl: blinkCtrl,
                      isCrit: isCrit,
                    ),

                    const SizedBox(width: 12),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  alert.title,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .3,
                                    color: !alert.isActive
                                        ? C.mutedLt
                                        : uiSev == UISeverity.resolved
                                        ? C.green
                                        : C.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Meta row
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: C.muted,
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  alert.resourceType ?? 'Unknown',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 9,
                                    color: C.muted,
                                    letterSpacing: .3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.sensors_rounded,
                                color: C.muted,
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                alert.resourceId ?? 'N/A',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 9,
                                  color: C.muted,
                                  letterSpacing: .3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Right column — badges + time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Severity badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: color.withOpacity(.1),
                            border: Border.all(color: color.withOpacity(.35)),
                          ),
                          child: Text(
                            uiSev.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              letterSpacing: 1.5,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatTime(alert.timestamp),
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: isCrit ? color : C.muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (!alert.isActive)
                          const Icon(
                            Icons.done_all_rounded,
                            color: C.green,
                            size: 14,
                          )
                        else
                          Icon(
                            uiAlert.isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: C.mutedLt,
                            size: 16,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── EXPANDED DETAIL PANEL ──
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: uiAlert.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: ExpandedDetail(
                alert: alert,
                color: color,
                onAcknowledge: onAcknowledge,
                onDismiss: onDismiss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
