import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';

class ResponseProgressBar extends StatelessWidget {
  final ResponseStatus status;
  final double glowT;
  const ResponseProgressBar({
    super.key,
    required this.status,
    required this.glowT,
  });

  @override
  Widget build(BuildContext ctx) {
    final stages = [
      ResponseStatus.pending,
      ResponseStatus.dispatched,
      ResponseStatus.onScene,
      ResponseStatus.clearing,
      ResponseStatus.closed,
    ];
    final currentIdx = stages.indexOf(status);

    return Column(
      children: [
        Row(
          children: List.generate(stages.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line
              final lineIdx = i ~/ 2;
              final isActive = lineIdx < currentIdx;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isActive
                      ? stages[lineIdx + 1].color.withOpacity(0.6)
                      : C.muted.withOpacity(0.2),
                ),
              );
            }
            final stageIdx = i ~/ 2;
            final s = stages[stageIdx];
            final isActive = stageIdx <= currentIdx;
            final isCurrent = stageIdx == currentIdx;
            final col = s.color;
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? col.withOpacity(0.18) : C.bgCard2,
                border: Border.all(
                  color: isActive
                      ? col.withOpacity(0.5 + (isCurrent ? glowT * 0.2 : 0))
                      : C.muted.withOpacity(0.2),
                  width: isCurrent ? 2 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: col.withOpacity(0.3 + glowT * 0.15),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                isActive ? Icons.check_rounded : Icons.circle_outlined,
                color: isActive ? col : C.muted.withOpacity(0.3),
                size: 12,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: stages
              .map(
                (s) => Expanded(
                  child: Text(
                    s.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6,
                      color: s == status ? s.color : C.muted.withOpacity(0.4),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
