import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/widgets/report_generator/preview_row.dart';

typedef C = AppColors;

// enum ReportStatus { idle, generating, ready }

class GenerateReportWidget extends StatelessWidget {
  final TextEditingController titleController;
  final ReportConfig config;
  final ReportStatus status;
  final Animation<double> glowAnimation;
  final VoidCallback? onGenerate;

  const GenerateReportWidget({
    super.key,
    required this.titleController,
    required this.config,
    required this.status,
    required this.glowAnimation,
    this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final canGenerate = config.types.isNotEmpty && status == ReportStatus.idle;
    final typeNames = config.types.map((t) => t.label).join(' + ');
    final estimatedSize =
        config.types.length * 80 +
        (config.includeCharts ? 120 : 0) +
        (config.includeRawData ? 200 : 0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview card
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.bgCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: C.green.withOpacity(0.2 + glowAnimation.value * 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.preview_rounded, size: 11, color: C.green),
                      const SizedBox(width: 6),
                      const Text(
                        'REPORT PREVIEW',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.green,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PreviewRow(
                    'Title',
                    titleController.text.isNotEmpty
                        ? titleController.text
                        : '(auto)',
                    C.white,
                  ),
                  PreviewRow('Types', typeNames, C.cyan),
                  PreviewRow('Format', config.format.label, C.amber),
                  PreviewRow('Period', config.period.label, C.violet),
                  PreviewRow('Est. size', '~$estimatedSize KB', C.mutedLt),
                  PreviewRow(
                    'Charts',
                    config.includeCharts ? 'YES' : 'NO',
                    config.includeCharts ? C.green : C.mutedLt,
                  ),
                  PreviewRow(
                    'Raw data',
                    config.includeRawData ? 'YES' : 'NO',
                    config.includeRawData ? C.cyan : C.mutedLt,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Generate button
          GestureDetector(
            onTap: canGenerate ? onGenerate : null,
            child: AnimatedBuilder(
              animation: glowAnimation,
              builder: (_, __) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color: canGenerate
                      ? C.green.withOpacity(0.12 + glowAnimation.value * 0.04)
                      : C.bgCard2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: canGenerate
                        ? C.green.withOpacity(0.5 + glowAnimation.value * 0.15)
                        : C.gBdr,
                  ),
                  boxShadow: canGenerate
                      ? [
                          BoxShadow(
                            color: C.green.withOpacity(
                              0.08 + glowAnimation.value * 0.06,
                            ),
                            blurRadius: 16,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: canGenerate ? C.green : C.mutedLt,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      canGenerate
                          ? 'GENERATE REPORT'
                          : (status == ReportStatus.generating
                                ? 'GENERATING...'
                                : 'SELECT TYPES TO CONTINUE'),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: canGenerate ? C.green : C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
