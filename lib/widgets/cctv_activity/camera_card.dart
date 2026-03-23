import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';

class CameraCard extends StatelessWidget {
  final CCTVCamera camera;
  final bool isSelected;
  final VoidCallback onTap;
  final AnimationController recordCtrl;
  final AnimationController glowCtrl;

  const CameraCard({
    super.key,
    required this.camera,
    required this.isSelected,
    required this.onTap,
    required this.recordCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([recordCtrl, glowCtrl]),
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(
              color: isSelected
                  ? camera.status.color.withOpacity(0.5)
                  : camera.status.color.withOpacity(0.2),
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: camera.status.color.withOpacity(0.3),
                  blurRadius: 12,
                ),
            ],
          ),
          child: Stack(
            children: [
              // Camera feed placeholder
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: C.bgCard2.withOpacity(0.5),
                ),
                height: 100,
                child: Center(
                  child: Icon(
                    camera.status.icon,
                    color: camera.status.color.withOpacity(0.5),
                    size: 32,
                  ),
                ),
              ),
              // Recording indicator
              if (camera.recording != RecordingMode.off)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: camera.recording.color.withOpacity(0.9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: C.white,
                            boxShadow: [
                              BoxShadow(
                                color: C.white.withOpacity(
                                  0.3 + recordCtrl.value * 0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          camera.recording.label,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 5.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Alert badge
              if (camera.hasAlert)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.red,
                      boxShadow: [
                        BoxShadow(
                          color: C.red.withOpacity(0.5 + glowCtrl.value * 0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
              // Info section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    color: C.bgCard.withOpacity(0.9),
                    border: Border(
                      top: BorderSide(
                        color: camera.status.color.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camera.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: C.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  camera.status.icon,
                                  color: camera.status.color,
                                  size: 10,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  camera.status.label,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 6,
                                    color: camera.status.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: C.cyan,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${camera.peopleCount}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 6,
                                  color: C.cyan,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
