import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';
import 'camera_grid_view.dart';
import 'camera_list_view.dart';

typedef C = AppColors;

enum ViewMode { grid, list }

/// A reusable widget to switch between grid and list views of cameras
class CameraView extends StatelessWidget {
  final ViewMode viewMode;
  final List<CCTVCamera> cameras;
  final String? selectedCameraId;
  final int unacknowledgedIncidents;
  final List<CCTVIncident> incidents;
  final ScrollController scrollController;
  final void Function(String cameraId) onCameraSelected;
  final AnimationController recordCtrl;
  final AnimationController glowCtrl;

  const CameraView({
    super.key,
    required this.viewMode,
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
    if (viewMode == ViewMode.grid) {
      return CameraGridView(
        cameras: cameras,
        selectedCameraId: selectedCameraId,
        unacknowledgedIncidents: unacknowledgedIncidents,
        incidents: incidents,
        scrollController: scrollController,
        onCameraSelected: onCameraSelected,
        recordCtrl: recordCtrl,
        glowCtrl: glowCtrl,
      );
    } else {
      return CameraListView(
        cameras: cameras,
        selectedCameraId: selectedCameraId,
        scrollController: scrollController,
        onCameraSelected: onCameraSelected,
        recordCtrl: recordCtrl,
      );
    }
  }
}
