import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/scenario_builder_data_model.dart';
import 'package:urban_os/widgets/scenario_builder/detail_item.dart';
import 'package:urban_os/widgets/scenario_builder/step_row.dart';

typedef C = AppColors;

class ScenarioCard extends StatefulWidget {
  final Scenario scenario;
  final bool isExpanded;
  final VoidCallback onTap;
  final AnimationController glowCtrl;

  const ScenarioCard({
    super.key,
    required this.scenario,
    required this.isExpanded,
    required this.onTap,
    required this.glowCtrl,
  });

  @override
  State<ScenarioCard> createState() => _ScenarioCardState();
}

class _ScenarioCardState extends State<ScenarioCard>
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
  void didUpdateWidget(covariant ScenarioCard oldWidget) {
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
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(
              color: widget.scenario.complexity.color.withOpacity(
                0.2 + _expandCtrl.value * 0.25,
              ),
            ),
            boxShadow: [
              if (widget.isExpanded)
                BoxShadow(
                  color: widget.scenario.complexity.color.withOpacity(0.15),
                  blurRadius: 14,
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
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        widget.scenario.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: widget.scenario.isFavorite
                            ? C.yellow
                            : C.mutedLt,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.scenario.name,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: C.white,
                            ),
                          ),
                          Text(
                            widget.scenario.description,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7,
                              color: C.mutedLt,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        color: widget.scenario.complexity.color.withOpacity(
                          0.15,
                        ),
                        border: Border.all(
                          color: widget.scenario.complexity.color.withOpacity(
                            0.3,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.scenario.complexity.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6,
                          color: widget.scenario.complexity.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status & Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: widget.scenario.status.color.withOpacity(0.2),
                      ),
                      child: Text(
                        widget.scenario.status.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 5.5,
                          color: widget.scenario.status.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: widget.scenario.progressPercent,
                          minHeight: 3,
                          backgroundColor: C.teal.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(C.teal),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.scenario.progressLabel,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        color: C.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Expanded Details
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
                        color: widget.scenario.complexity.color.withOpacity(
                          0.15,
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DetailItem(
                              'STEPS',
                              '${widget.scenario.steps.length}',
                              C.cyan,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailItem(
                              'DURATION',
                              '${(widget.scenario.durationSeconds / 60).toStringAsFixed(0)}m',
                              C.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DetailItem(
                              'SUCCESS',
                              '${widget.scenario.successMetrics}%',
                              widget.scenario.successMetrics > 80
                                  ? C.green
                                  : widget.scenario.successMetrics > 50
                                  ? C.yellow
                                  : C.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (widget.scenario.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.scenario.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: C.teal.withOpacity(0.1),
                                    border: Border.all(
                                      color: C.teal.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 6,
                                      color: C.teal,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      if (widget.scenario.steps.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'EXECUTION STEPS',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.cyan,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...widget.scenario.steps.map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: StepRow(step: step),
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
