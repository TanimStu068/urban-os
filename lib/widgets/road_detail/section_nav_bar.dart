import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;
const kAccent = C.cyan;

class SectionNavBar extends StatelessWidget {
  final List<String> sections;
  final List<IconData> sectionIcons;
  final int activeSection;
  final List<GlobalKey> sectionKeys;
  final AnimationController chartCtrl;
  final ValueChanged<int> onSectionChanged;

  const SectionNavBar({
    super.key,
    required this.sections,
    required this.sectionIcons,
    required this.activeSection,
    required this.sectionKeys,
    required this.chartCtrl,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        itemCount: sections.length,
        itemBuilder: (_, i) {
          final isSel = i == activeSection;
          return GestureDetector(
            onTap: () {
              onSectionChanged(i);
              chartCtrl.forward(from: 0);
              final ctx = sectionKeys[i].currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(
                  ctx,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: isSel
                    ? kAccent.withOpacity(0.15)
                    : C.bgCard.withOpacity(0.8),
                border: Border.all(
                  color: isSel ? kAccent.withOpacity(0.5) : C.gBdr,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sectionIcons[i],
                    color: isSel ? kAccent : C.muted,
                    size: 11,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    sections[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      letterSpacing: 1,
                      color: isSel ? kAccent : C.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
