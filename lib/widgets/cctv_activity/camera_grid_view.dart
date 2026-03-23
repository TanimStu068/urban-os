import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';
import 'package:urban_os/widgets/cctv_activity/camera_card.dart';
import 'package:urban_os/widgets/cctv_activity/incident_card.dart';

typedef C = AppColors;

/// A reusable camera grid view widget with incidents
class CameraGridView extends StatelessWidget {
  final List<CCTVCamera> cameras;
  final String? selectedCameraId;
  final int unacknowledgedIncidents;
  final List<CCTVIncident> incidents;
  final ScrollController scrollController;
  final void Function(String cameraId) onCameraSelected;
  final AnimationController recordCtrl;
  final AnimationController glowCtrl;

  const CameraGridView({
    super.key,
    required this.cameras,
    required this.selectedCameraId,
    required this.unacknowledgedIncidents,
    required this.incidents,
    required this.scrollController,
    required this.onCameraSelected,
    required this.recordCtrl,
    required this.glowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: cameras.length,
            itemBuilder: (_, i) => CameraCard(
              camera: cameras[i],
              isSelected: selectedCameraId == cameras[i].id,
              onTap: () => onCameraSelected(cameras[i].id),
              recordCtrl: recordCtrl,
              glowCtrl: glowCtrl,
            ),
          ),
          if (unacknowledgedIncidents > 0) ...[
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'RECENT INCIDENTS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: C.orange,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...incidents
                .where((i) => !i.acknowledged)
                .map(
                  (incident) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: IncidentCard(incident: incident),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
