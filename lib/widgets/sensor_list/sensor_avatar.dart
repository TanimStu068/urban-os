import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';

typedef T = AppColors;

class SensorAvatar extends StatelessWidget {
  final SensorType type;
  final CatMeta cat;
  final SensorState state;
  final double size;

  const SensorAvatar({
    super.key,
    required this.type,
    required this.cat,
    required this.state,
    this.size = 44,
  });

  IconData _iconForType(SensorType t) {
    switch (t.category) {
      case 'Traffic':
        return Icons.directions_car_rounded;
      case 'Energy':
        return Icons.bolt_rounded;
      case 'Environment':
        return Icons.eco_rounded;
      case 'Safety':
        return Icons.security_rounded;
      default:
        return Icons.device_hub_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStateColor = stateColor(state); // ✅ renamed variable

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: cat.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size * 0.28),
            border: Border.all(color: cat.color.withOpacity(0.3)),
          ),
          child: Icon(_iconForType(type), color: cat.color, size: size * 0.46),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: currentStateColor, // ✅ use the renamed variable
              shape: BoxShape.circle,
              border: Border.all(color: T.bg, width: 2),
              boxShadow: [
                BoxShadow(
                  color: currentStateColor.withOpacity(0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
