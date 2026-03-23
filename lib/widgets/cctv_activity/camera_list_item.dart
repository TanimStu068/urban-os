import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';

class CameraListItem extends StatelessWidget {
  final CCTVCamera camera;
  final bool isSelected;
  final VoidCallback onTap;
  final AnimationController recordCtrl;

  const CameraListItem({
    super.key,
    required this.camera,
    required this.isSelected,
    required this.onTap,
    required this.recordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: recordCtrl,
        builder: (_, __) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(
              color: isSelected
                  ? camera.status.color.withOpacity(0.5)
                  : camera.status.color.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(camera.status.icon, color: camera.status.color, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camera.name,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: C.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          camera.location,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 7,
                            color: C.mutedLt,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          camera.zone,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 6.5,
                            color: C.cyan,
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
                  Row(
                    children: [
                      Icon(Icons.people_rounded, color: C.cyan, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        '${camera.peopleCount}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: C.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: camera.recording.color.withOpacity(0.15),
                    ),
                    child: Text(
                      camera.recording.label,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 5.5,
                        color: camera.recording.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
