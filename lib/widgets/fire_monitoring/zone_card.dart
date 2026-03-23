import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/fire_monitoring_data_model.dart';
import 'package:urban_os/widgets/fire_monitoring/detail_row.dart';

typedef C = AppColors;

class ZoneCard extends StatefulWidget {
  final FireZone zone;
  final bool isExpanded;
  final VoidCallback onTap;
  final AnimationController glowCtrl;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.isExpanded,
    required this.onTap,
    required this.glowCtrl,
  });

  @override
  State<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends State<ZoneCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandCtrl;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.isExpanded) _expandCtrl.forward();
  }

  @override
  void didUpdateWidget(covariant ZoneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandCtrl.forward();
      } else {
        _expandCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_expandCtrl, widget.glowCtrl]),
      builder: (_, __) => GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.zone.intensity.color.withOpacity(0.08),
            border: Border.all(
              color: widget.zone.intensity.color.withOpacity(
                0.25 + _expandCtrl.value * 0.3,
              ),
            ),
            boxShadow: [
              if (widget.isExpanded)
                BoxShadow(
                  color: widget.zone.intensity.color.withOpacity(0.15),
                  blurRadius: 16,
                ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.zone.status.color.withOpacity(0.15),
                        border: Border.all(
                          color: widget.zone.status.color.withOpacity(0.4),
                        ),
                      ),
                      child: Icon(
                        widget.zone.status.icon,
                        color: widget.zone.status.color,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'L${widget.zone.level} · ${widget.zone.name}',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: widget.zone.intensity.color,
                            ),
                          ),
                          Text(
                            widget.zone.status.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: widget.zone.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.zone.temperature.toStringAsFixed(0)}°C',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: widget.zone.intensity.color,
                          ),
                        ),
                        Text(
                          widget.zone.intensity.label,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: widget.zone.intensity.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Progress bar (temperature)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (widget.zone.temperature / 1500).clamp(0, 1),
                    minHeight: 4,
                    backgroundColor: widget.zone.intensity.color.withOpacity(
                      0.1,
                    ),
                    valueColor: AlwaysStoppedAnimation(
                      widget.zone.intensity.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Expanded content
              SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _expandCtrl,
                  curve: Curves.easeOut,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: widget.zone.intensity.color.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      DetailRow(
                        label: 'VISIBILITY',
                        value: '${widget.zone.visibility.toStringAsFixed(0)}%',
                        color: C.cyan,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DetailRow(
                              label: 'SPREAD RATE',
                              value:
                                  '${widget.zone.spreadRate.toStringAsFixed(1)} m/s',
                              color: C.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailRow(
                              label: 'EVAC TIME',
                              value: widget.zone.evactimeDisplay,
                              color: C.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DetailRow(
                              label: 'PEOPLE',
                              value: '${widget.zone.peopleInZone}',
                              color: C.pink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailRow(
                              label: 'DANGER',
                              value: widget.zone.dangerLevel,
                              color: widget.zone.intensity.color,
                            ),
                          ),
                        ],
                      ),
                      if (widget.zone.equipment.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'EQUIPMENT',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: C.cyan,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.zone.equipment
                              .map(
                                (eq) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: C.cyan.withOpacity(0.15),
                                  ),
                                  child: Text(
                                    eq,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 6,
                                      color: C.cyan,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
