import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';

typedef C = AppColors;

/// A widget that displays the progress panel for report generation.
class ProgressPanelWidget extends StatelessWidget {
  final ReportStatus status;
  final double generateProgress; // 0.0 to 1.0
  final String generateStep;
  final Animation<double> blinkAnimation;
  final VoidCallback? onDismiss;

  const ProgressPanelWidget({
    super.key,
    required this.status,
    required this.generateProgress,
    required this.generateStep,
    required this.blinkAnimation,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == ReportStatus.ready;
    final col = isDone ? C.green : C.cyan;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: AnimatedBuilder(
        animation: blinkAnimation,
        builder: (_, __) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: col.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: col.withOpacity(
                isDone ? 0.4 : 0.25 + blinkAnimation.value * 0.1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!isDone)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: col,
                      ),
                    ),
                  if (isDone)
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: col,
                      size: 14,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    generateStep,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: col,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(generateProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                      color: col,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: C.bgCard2,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOut,
                    widthFactor: generateProgress,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [col.withOpacity(0.6), col],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
              if (isDone) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.download_rounded, color: col, size: 12),
                    const SizedBox(width: 6),
                    Text(
                      'READY TO DOWNLOAD',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        color: col,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    if (onDismiss != null)
                      GestureDetector(
                        onTap: onDismiss,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: col.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: col.withOpacity(0.4)),
                          ),
                          child: Text(
                            'DISMISS',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 7.5,
                              color: col,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
