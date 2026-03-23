import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';

typedef _C = AppColors;

class SectionHeader extends StatelessWidget {
  final Section section;
  const SectionHeader({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: section.color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(section.icon, color: section.color, size: 13),
                const SizedBox(width: 7),
                Text(
                  section.label.toUpperCase(),
                  style: TextStyle(
                    color: section.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: _C.border)),
          const SizedBox(width: 10),
          Text(
            '${section.entries.length}',
            style: const TextStyle(color: _C.textSub, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
