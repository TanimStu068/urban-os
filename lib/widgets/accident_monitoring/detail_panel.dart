import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/detail_tab.dart';
import 'package:urban_os/widgets/accident_monitoring/impact_tab.dart';
import 'package:urban_os/widgets/accident_monitoring/incident_hero.dart';
import 'package:urban_os/widgets/accident_monitoring/overview_tab.dart';
import 'package:urban_os/widgets/accident_monitoring/response_tab.dart';
import 'package:urban_os/widgets/accident_monitoring/time_line_tab.dart';

class DetailPanel extends StatelessWidget {
  final AccidentEvent accident;
  final int selectedTab;
  final List<AccidentEvent> allAccidents;
  final ValueChanged<int> onTabChanged;
  final AnimationController glowCtrl;
  final VoidCallback onCloseIncident;

  const DetailPanel({
    super.key,
    required this.accident,
    required this.allAccidents,
    required this.selectedTab,
    required this.onTabChanged,
    required this.glowCtrl,
    required this.onCloseIncident,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) {
        return Column(
          children: [
            // ① Incident Hero
            IncidentHero(
              acc: accident,
              glowCtrl: glowCtrl,
              onCloseIncident: onCloseIncident,
            ),

            const SizedBox(height: 10),

            // ② Detail tabs
            DetailTabs(selectedIndex: selectedTab, onTabChanged: onTabChanged),

            const SizedBox(height: 10),

            // ③ Tab content
            _buildTabContent(),
          ],
        );
      },
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return OverviewTab(
          accident: accident,
          accidents: allAccidents,
          waveT: glowCtrl.value,
          pulseT: glowCtrl.value,
          glowT: glowCtrl.value,
        );
      case 1:
        return TimelineTab(accident: accident, glowT: glowCtrl.value);
      case 2:
        return ResponseTab(accident: accident, glowT: glowCtrl.value);
      case 3:
        return ImpactTab(
          accident: accident,
          glowT: glowCtrl.value,
          radarT: glowCtrl.value,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
