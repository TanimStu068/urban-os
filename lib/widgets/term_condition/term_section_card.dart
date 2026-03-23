import 'package:flutter/material.dart';
import 'package:urban_os/widgets/term_condition/term_section.dart';

class TermSectionCard extends StatelessWidget {
  final TermSection section;
  final bool isExpanded;
  final VoidCallback onTap;

  const TermSectionCard({
    super.key,
    required this.section,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isExpanded
            ? section.color.withOpacity(0.06)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? section.color.withOpacity(0.3)
              : Colors.white.withOpacity(0.07),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      section.number,
                      style: TextStyle(
                        color: section.color.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(section.icon, color: section.color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        section.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withOpacity(0.4),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: section.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: section.color.withOpacity(0.15)),
                  ),
                  child: Text(
                    section.highlight,
                    style: TextStyle(
                      color: section.color.withOpacity(0.9),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 14),
                  Container(height: 1, color: Colors.white.withOpacity(0.06)),
                  const SizedBox(height: 14),
                  Text(
                    section.content,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
