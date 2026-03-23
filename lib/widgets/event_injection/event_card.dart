import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';
import 'package:flutter/material.dart';
import 'package:urban_os/widgets/event_injection/detail_item.dart';

typedef C = AppColors;

class EventCard extends StatefulWidget {
  final InjectedEvent event;
  final AnimationController pulseCtrl;

  const EventCard({super.key, required this.event, required this.pulseCtrl});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.pulseCtrl,
      builder: (_, __) => GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.event.type.color.withOpacity(0.08),
            border: Border.all(
              color: widget.event.type.color.withOpacity(0.25),
            ),
            boxShadow: widget.event.status == EventStatus.active
                ? [
                    BoxShadow(
                      color: widget.event.type.color.withOpacity(0.15),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      widget.event.type.icon,
                      color: widget.event.type.color,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.description,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: C.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.event.location,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.mutedLt,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: widget.event.status.color.withOpacity(0.2),
                          ),
                          child: Text(
                            widget.event.status.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 6,
                              color: widget.event.status.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.event.timeRemaining,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: widget.event.type.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: widget.event.progressPercent,
                    minHeight: 3,
                    backgroundColor: widget.event.type.color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(widget.event.type.color),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Color(0x22FFFFFF), height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DetailItem(
                              'SEVERITY',
                              widget.event.severity.label,
                              widget.event.severity.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailItem(
                              'IMPACT',
                              widget.event.impactArea.label,
                              C.cyan,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      DetailItem(
                        'SYSTEMS',
                        '${widget.event.systemsAffected}',
                        C.yellow,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
