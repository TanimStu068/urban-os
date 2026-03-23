import 'package:flutter/material.dart';
import 'package:urban_os/widgets/district_detail/matrict_item.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class MetricGrid extends StatelessWidget {
  final List<MetricItem> items;
  const MetricGrid(this.items, {super.key});

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1.6,
    children: items
        .map(
          (m) => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: m.color.withOpacity(0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.icon, color: m.color, size: 12),
                const SizedBox(height: 4),
                Text(
                  m.value,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 10,
                    color: m.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  m.label,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6,
                    color: AppColors.mutedLt,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}
