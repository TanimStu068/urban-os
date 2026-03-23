import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';
import 'package:urban_os/widgets/emergency_control/detail_row.dart';

typedef C = AppColors;

class AlertCard extends StatefulWidget {
  final EmergencyAlert alert;
  final bool isExpanded;
  final VoidCallback onTap;
  final AnimationController glowCtrl;

  const AlertCard({
    super.key,
    required this.alert,
    required this.isExpanded,
    required this.onTap,
    required this.glowCtrl,
  });

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard>
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
  void didUpdateWidget(covariant AlertCard oldWidget) {
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
            color: widget.alert.severity.bgColor,
            border: Border.all(
              color: widget.alert.severity.color.withOpacity(
                0.3 + _expandCtrl.value * 0.3,
              ),
            ),
            boxShadow: [
              if (widget.isExpanded)
                BoxShadow(
                  color: widget.alert.severity.color.withOpacity(0.2),
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
                    Icon(
                      widget.alert.type.icon,
                      color: widget.alert.type.color,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.alert.title,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: widget.alert.severity.color,
                            ),
                          ),
                          Text(
                            widget.alert.location,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: widget.alert.status.color.withOpacity(0.2),
                      ),
                      child: Text(
                        widget.alert.status.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          fontWeight: FontWeight.w700,
                          color: widget.alert.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        color: widget.alert.severity.color.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Description
                      DetailRow(
                        label: 'INCIDENT',
                        value: widget.alert.description,
                        color: C.cyan,
                      ),
                      const SizedBox(height: 8),
                      // Time & ETA
                      Row(
                        children: [
                          Expanded(
                            child: DetailRow(
                              label: 'REPORTED',
                              value: widget.alert.timeAgo,
                              color: C.yellow,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailRow(
                              label: 'ETA',
                              value: widget.alert.eta,
                              color: widget.alert.status.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Teams & People
                      Row(
                        children: [
                          Expanded(
                            child: DetailRow(
                              label: 'TEAMS',
                              value: '${widget.alert.assignedTeams.length}',
                              color: C.teal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailRow(
                              label: 'AFFECTED',
                              value: '${widget.alert.affectedPeople}',
                              color: C.orange,
                            ),
                          ),
                        ],
                      ),
                      if (widget.alert.requiresEvacuation) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: C.red.withOpacity(0.15),
                            border: Border.all(color: C.red.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.emergency_rounded,
                                color: C.red,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Text(
                                  'EVACUATION REQUIRED',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 7,
                                    fontWeight: FontWeight.w700,
                                    color: C.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
