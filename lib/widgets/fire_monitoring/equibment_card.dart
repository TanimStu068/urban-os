import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/fire_monitoring_data_model.dart';

class EquipmentCard extends StatelessWidget {
  final FireEquipment equipment;

  const EquipmentCard({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: equipment.status.color.withOpacity(0.08),
        border: Border.all(color: equipment.status.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                equipment.type == EquipmentType.sprinkler
                    ? Icons.water_drop_rounded
                    : equipment.type == EquipmentType.foam
                    ? Icons
                          .bubble_chart_rounded // instead of bubbles_rounded
                    : equipment.type == EquipmentType.ventilation
                    ? Icons.air_rounded
                    : equipment.type == EquipmentType.firewall
                    ? Icons
                          .wallpaper_rounded // instead of wall_rounded
                    : Icons.sensors_rounded,
                color: equipment.status.color,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      equipment.name,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: equipment.status.color,
                      ),
                    ),
                    Text(
                      'Floor ${equipment.floorLocation} • ${equipment.status.label}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 6.5,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: equipment.status.color.withOpacity(0.15),
                ),
                child: Text(
                  '${equipment.efficiency.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: equipment.status.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: equipment.efficiency / 100,
              minHeight: 4,
              backgroundColor: equipment.status.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(equipment.status.color),
            ),
          ),
          if (equipment.waterRemaining < 5000) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.water_drop_rounded, color: C.cyan, size: 10),
                const SizedBox(width: 4),
                Text(
                  equipment.waterPercent,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 6.5,
                    color: C.cyan,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
