import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/power_grid_data_model.dart';

typedef C = AppColors;

class AlertPanel extends StatelessWidget {
  final List<GridAlert> alerts;
  final int unackAlerts;
  final bool isOpen;
  final Animation<double> blinkAnimation;
  final VoidCallback onClose;
  final VoidCallback onAckAll;
  final void Function(GridAlert alert) onAck;

  const AlertPanel({
    super.key,
    required this.alerts,
    required this.unackAlerts,
    required this.isOpen,
    required this.blinkAnimation,
    required this.onClose,
    required this.onAckAll,
    required this.onAck,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: blinkAnimation,
      builder: (_, __) => Container(
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: C.bgCard.withOpacity(0.97),
          border: Border.all(
            color: C.red.withOpacity(0.25 + blinkAnimation.value * 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: C.red,
                  size: 13,
                ),
                const SizedBox(width: 7),
                Text(
                  'GRID ALERTS  ·  $unackAlerts UNACKNOWLEDGED',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: C.red,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                if (unackAlerts > 0)
                  GestureDetector(
                    onTap: onAckAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: C.amber.withOpacity(0.1),
                        border: Border.all(color: C.amber.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'ACK ALL',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7,
                          color: C.amber,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close_rounded,
                    color: C.mutedLt,
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0x1AFFAA00), height: 1),
            const SizedBox(height: 8),
            // Alert items
            ...alerts.map(
              (a) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: a.color.withOpacity(a.acked ? 0.02 : 0.06),
                  border: Border.all(
                    color: a.color.withOpacity(
                      a.acked
                          ? 0.08
                          : a.color == C.red
                          ? 0.3 + blinkAnimation.value * 0.1
                          : 0.2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      a.acked
                          ? Icons.check_circle_outline_rounded
                          : Icons.warning_amber_rounded,
                      color: a.color.withOpacity(a.acked ? 0.4 : 1),
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.message,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              color: a.acked ? C.muted : C.white,
                              fontWeight: a.acked
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${a.nodeId}  ·  ${a.time}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onAck(a),
                      child: a.acked
                          ? const Icon(
                              Icons.check_rounded,
                              color: C.muted,
                              size: 12,
                            )
                          : Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: a.color.withOpacity(0.1),
                                border: Border.all(
                                  color: a.color.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: a.color,
                                size: 10,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
