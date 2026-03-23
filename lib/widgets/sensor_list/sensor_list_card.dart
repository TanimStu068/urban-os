import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/sensor_list/footer_metric.dart';
import 'package:urban_os/widgets/sensor_list/live_value.dart';
import 'package:urban_os/widgets/sensor_list/mini_tag.dart';
import 'package:urban_os/widgets/sensor_list/sensor_avatar.dart';
import 'package:urban_os/widgets/sensor_list/spark_bar.dart';
import 'package:urban_os/widgets/sensor_list/state_chip.dart';

typedef T = AppColors;

class SensorListCard extends StatefulWidget {
  final SensorModel sensor;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SensorListCard({
    super.key,
    required this.sensor,
    required this.isPinned,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<SensorListCard> createState() => _SensorListCardState();
}

class _SensorListCardState extends State<SensorListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sensor;
    final cat = catOf(s.type);
    // final stateColor = stateColor(s.state);
    final currentStateColor = stateColor(s.state);
    final reading = s.latestReading;
    final isAlert = reading?.isAlert ?? false;
    final batPct = s.batteryPercentage ?? 100;
    final signalRssi = s.signalStrength ?? -50;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) => _press.reverse(),
      onTapCancel: () => _press.reverse(),
      child: AnimatedBuilder(
        animation: _press,
        builder: (_, child) =>
            Transform.scale(scale: 1 - _press.value * 0.015, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: widget.isPinned
                ? cat.color.withOpacity(0.09)
                : (isAlert ? T.red.withOpacity(0.07) : T.surface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isPinned
                  ? cat.color.withOpacity(0.45)
                  : (isAlert ? T.red.withOpacity(0.35) : T.border),
              width: widget.isPinned ? 1.5 : 1,
            ),
            boxShadow: widget.isPinned
                ? [
                    BoxShadow(
                      color: cat.color.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              // ── Main row ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(
                  children: [
                    // Icon / status
                    SensorAvatar(type: s.type, cat: cat, state: s.state),
                    const SizedBox(width: 14),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.name,
                                  style: const TextStyle(
                                    color: T.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isAlert)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: T.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: T.red.withOpacity(0.4),
                                    ),
                                  ),
                                  child: const Text(
                                    'ALERT',
                                    style: TextStyle(
                                      color: T.red,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.my_location_rounded,
                                color: T.textSecondary,
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  s.location ??
                                      s.districtId
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                  style: const TextStyle(
                                    color: T.textSecondary,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: MiniTag(
                                  label: s.id.toUpperCase(),
                                  color: cat.color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: MiniTag(
                                  label: s.type.displayName,
                                  color: T.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Reading
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (reading != null) ...[
                          LiveValue(
                            value: reading.value,
                            unit: reading.unit ?? s.type.unit,
                            color: isAlert ? T.red : cat.color,
                          ),
                        ] else
                          Text(
                            '—',
                            style: TextStyle(color: T.textMuted, fontSize: 18),
                          ),
                        const SizedBox(height: 6),
                        StateChip(state: s.state, color: currentStateColor),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Footer metrics ────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: T.border.withOpacity(0.7),
                      width: 0.8,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                child: Row(
                  children: [
                    FooterMetric(
                      icon: Icons.battery_full_rounded,
                      label: '$batPct%',
                      color: batPct > 50
                          ? T.green
                          : batPct > 20
                          ? T.amber
                          : T.red,
                    ),
                    const SizedBox(width: 16),
                    FooterMetric(
                      icon: Icons.signal_wifi_4_bar_rounded,
                      label: '$signalRssi dBm',
                      color: signalRssi > -60
                          ? T.green
                          : signalRssi > -75
                          ? T.amber
                          : T.red,
                    ),
                    const SizedBox(width: 16),
                    if (s.lastMaintenanceDate != null)
                      FooterMetric(
                        icon: Icons.build_circle_outlined,
                        label: _formatDate(s.lastMaintenanceDate!),
                        color: T.textSecondary,
                      ),
                    const Spacer(),
                    SparkBar(reading: reading?.value ?? 0, cat: cat),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year.toString().substring(2)}';
}
