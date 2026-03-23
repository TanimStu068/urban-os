import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/cctv_activity/stat_item.dart';

typedef C = AppColors;

/// A reusable camera statistics bar
class CameraStatsBar extends StatelessWidget {
  final int onlineCameras;
  final int recordingCount;
  final int alertsCount;
  final int peopleCount;

  const CameraStatsBar({
    super.key,
    required this.onlineCameras,
    required this.recordingCount,
    required this.alertsCount,
    required this.peopleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: C.bgCard.withOpacity(0.85),
        border: Border.all(color: C.red.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem('ONLINE', '$onlineCameras', C.green),
          StatItem('RECORDING', '$recordingCount', C.red),
          StatItem('ALERTS', '$alertsCount', C.orange),
          StatItem('PEOPLE', '$peopleCount', C.cyan),
        ],
      ),
    );
  }
}
