import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/overview_tab.dart';
import 'package:urban_os/widgets/traffic_dashboard/incident_tab.dart';
import 'package:urban_os/widgets/traffic_dashboard/parking_tab.dart';
import 'package:urban_os/widgets/traffic_dashboard/road_tap.dart';
import 'package:urban_os/widgets/traffic_dashboard/signal_tab.dart';

class TrafficTabs extends StatelessWidget {
  final int selectedTab;

  final List<RoadSegment> roads;
  final List<LiveVehicle> vehicles;
  final Map<String, double> liveStats;
  final AnimationController glowCtrl;
  final AnimationController blinkCtrl;
  final AnimationController pulseCtrl;
  final AnimationController flowCtrl;
  final AnimationController chartDrawCtrl;

  final int selectedRoadIdx;
  final Function(int) onSelectRoad;

  final List<TrafficLight> lights;
  final List<TrafficIncident> incidents;
  final List<ParkingZone> zones;

  final Function(dynamic) onToggleAdaptive;
  final Function(dynamic, String) onForcePhase;
  final Function(dynamic) onResolve;

  const TrafficTabs({
    super.key,
    required this.selectedTab,
    required this.roads,
    required this.vehicles,
    required this.liveStats,
    required this.glowCtrl,
    required this.blinkCtrl,
    required this.pulseCtrl,
    required this.flowCtrl,
    required this.chartDrawCtrl,
    required this.selectedRoadIdx,
    required this.onSelectRoad,
    required this.lights,
    required this.incidents,
    required this.zones,
    required this.onToggleAdaptive,
    required this.onForcePhase,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case 0:
        return OverviewTab(
          roads: roads,
          vehicles: vehicles,
          liveStats: liveStats,
          glowCtrl: glowCtrl,
          blinkCtrl: blinkCtrl,
          pulseCtrl: pulseCtrl,
          flowCtrl: flowCtrl,
          chartDrawCtrl: chartDrawCtrl,
          selectedRoad: selectedRoadIdx,
          onSelectRoad: onSelectRoad,
        );

      case 1:
        return RoadsTab(
          roads: roads,
          glowCtrl: glowCtrl,
          blinkCtrl: blinkCtrl,
          chartDrawCtrl: chartDrawCtrl,
          selected: selectedRoadIdx,
          onSelect: (i) {
            onSelectRoad(i);
            chartDrawCtrl.forward(from: 0);
          },
        );

      case 2:
        return SignalsTab(
          lights: lights,
          glowCtrl: glowCtrl,
          blinkCtrl: blinkCtrl,
          pulseCtrl: pulseCtrl,
          onToggleAdaptive: onToggleAdaptive,
          onForcePhase: onForcePhase,
        );

      case 3:
        return IncidentsTab(
          incidents: incidents,
          glowCtrl: glowCtrl,
          blinkCtrl: blinkCtrl,
          onResolve: onResolve,
        );

      case 4:
        return ParkingTab(
          zones: zones,
          glowCtrl: glowCtrl,
          pulseCtrl: pulseCtrl,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
