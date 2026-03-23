import 'package:flutter/material.dart';
import 'package:urban_os/widgets/about_app/tech_item.dart';

class TechChip extends StatelessWidget {
  final TechItem item;
  const TechChip({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, color: item.color, size: 16),
          const SizedBox(width: 8),
          Text(
            item.name,
            style: TextStyle(
              color: item.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
