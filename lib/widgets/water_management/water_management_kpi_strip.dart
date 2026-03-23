import 'package:flutter/material.dart';
import 'water_management_models.dart';
import 'water_management_shared.dart';

class WaterManagementKpiStrip extends StatelessWidget {
  final List<KpiDef> items;

  const WaterManagementKpiStrip({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            constraints: const BoxConstraints(minWidth: 115),
            decoration: BoxDecoration(
              color: C.bgCard,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: item.color.withOpacity(.2)),
              boxShadow: [
                BoxShadow(color: item.color.withOpacity(.06), blurRadius: 10),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 15),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WaterLabel(text: item.label, size: 8.5, letterSpacing: .8),
                    Text(
                      item.value,
                      style: TextStyle(
                        color: item.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    WaterLabel(
                      text: item.sub,
                      color: item.subColor ?? C.mutedHi,
                      size: 8,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
