import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'district_card.dart';

typedef C = AppColors;

class DistrictListView extends StatelessWidget {
  final List<DistrictModel> items;
  final ScrollController scrollController;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final Animation<double> pulseAnimation;
  final void Function(DistrictModel) openDetails;
  final void Function(DistrictModel) openAnalysis;
  final VoidCallback openMap;

  const DistrictListView({
    super.key,
    required this.items,
    required this.scrollController,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.pulseAnimation,
    required this.openDetails,
    required this.openAnalysis,
    required this.openMap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: C.mutedLt, size: 40),
            const SizedBox(height: 12),
            const Text(
              'No districts match filters',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: C.mutedLt,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      itemBuilder: (_, i) => DistrictCard(
        district: items[i],
        glowAnimation: glowAnimation,
        blinkAnimation: blinkAnimation,
        pulseAnimation: pulseAnimation,
        openDetails: openDetails,
        openAnalysis: openAnalysis,
        openMap: openMap,
      ),
    );
  }
}
