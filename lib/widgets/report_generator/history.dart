import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/prediction/section_header.dart';

typedef C = AppColors;

class HistoryWidget extends StatelessWidget {
  final List history;

  const HistoryWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SectionHeader('REPORT HISTORY', C.violet),
                const Spacer(),
                Text(
                  '${history.length} TOTAL',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7.5,
                    color: C.mutedLt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...history.take(6).map((r) {
              final ago = DateTime.now().difference(r.generatedAt);
              final agoStr = ago.inMinutes < 60
                  ? '${ago.inMinutes}m ago'
                  : ago.inHours < 24
                  ? '${ago.inHours}h ago'
                  : '${ago.inDays}d ago';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: C.bgCard2,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: C.gBdr),
                ),
                child: Row(
                  children: [
                    // Type icons
                    SizedBox(
                      width: 32,
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: r.config.types
                            .take(2)
                            .map(
                              (t) => Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: t.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Icon(t.icon, size: 9, color: t.color),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: C.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                r.config.format.label,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: C.cyan,
                                ),
                              ),
                              const Text(
                                ' · ',
                                style: TextStyle(color: C.mutedLt, fontSize: 7),
                              ),
                              Text(
                                r.config.period.label,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: C.mutedLt,
                                ),
                              ),
                              const Text(
                                ' · ',
                                style: TextStyle(color: C.mutedLt, fontSize: 7),
                              ),
                              Text(
                                '${r.recordCount} records',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 7,
                                  color: C.mutedLt,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${r.sizeKb}KB',
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            color: C.green,
                          ),
                        ),
                        Text(
                          agoStr,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.mutedLt,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.download_rounded,
                      color: C.mutedLt.withOpacity(0.5),
                      size: 16,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
