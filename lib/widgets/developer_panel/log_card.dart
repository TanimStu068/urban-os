import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';

class LogCard extends StatefulWidget {
  final DebugLog log;
  final bool isExpanded;
  final VoidCallback onTap;

  const LogCard({
    super.key,
    required this.log,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> with SingleTickerProviderStateMixin {
  late AnimationController _expandCtrl;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    if (widget.isExpanded) _expandCtrl.forward();
  }

  @override
  void didUpdateWidget(covariant LogCard oldWidget) {
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
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _expandCtrl,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: C.bgCard.withOpacity(0.8),
            border: Border.all(
              color: widget.log.level.color.withOpacity(
                0.2 + _expandCtrl.value * 0.15,
              ),
            ),
            boxShadow: [
              if (widget.isExpanded)
                BoxShadow(
                  color: widget.log.level.color.withOpacity(0.1),
                  blurRadius: 12,
                ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: widget.log.level.color.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          widget.log.level.label[0],
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8,
                            color: widget.log.level.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.log.level.label,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: widget.log.level.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.log.module}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: C.mutedLt,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${widget.log.timestamp.hour.toString().padLeft(2, '0')}:${widget.log.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 6,
                                  color: C.mutedLt,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.log.message,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.white,
                            ),
                            maxLines: widget.isExpanded ? 5 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isExpanded && widget.log.stackTrace != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: C.bgCard2.withOpacity(0.8),
                      border: Border.all(
                        color: widget.log.level.color.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      widget.log.stackTrace ?? '',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6,
                        color: C.mutedLt,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
