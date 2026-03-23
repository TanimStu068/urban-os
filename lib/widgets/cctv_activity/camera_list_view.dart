import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';
import 'package:urban_os/widgets/cctv_activity/camera_list_item.dart';

/// A reusable camera list view widget
class CameraListView extends StatelessWidget {
  final List<CCTVCamera> cameras;
  final String? selectedCameraId;
  final ScrollController scrollController;
  final void Function(String cameraId) onCameraSelected;
  final AnimationController recordCtrl;

  const CameraListView({
    super.key,
    required this.cameras,
    required this.selectedCameraId,
    required this.scrollController,
    required this.onCameraSelected,
    required this.recordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: cameras
            .map(
              (camera) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CameraListItem(
                  camera: camera,
                  isSelected: selectedCameraId == camera.id,
                  onTap: () => onCameraSelected(camera.id),
                  recordCtrl: recordCtrl,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
