import 'package:flutter/material.dart';
import 'water_management_models.dart';
import 'water_management_header.dart';
import 'water_management_kpi_strip.dart';
import 'water_management_tab_bar.dart';
import 'water_management_tab_body.dart';
import 'water_management_painters.dart';

class WaterManagementPage extends StatelessWidget {
  final bool liveData;
  final int tab;
  final int? selectedTank;
  final int? selectedPump;
  final double flowAnimValue;
  final double blinkAnimValue;
  final double pulseAnimValue;
  final List<WaterTank> tanks;
  final List<WaterPipe> pipes;
  final List<WaterPump> pumps;
  final List<DistZone> zones;
  final List<WaterAlert> alerts;
  final List<HrUsage> hourly;
  final VoidCallback onBack;
  final VoidCallback onShowAlertTab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<int?> onTankSelected;
  final ValueChanged<int?> onPumpSelected;
  final VoidCallback onToggleLive;

  final List<KpiDef> kpis;

  const WaterManagementPage({
    super.key,
    required this.liveData,
    required this.tab,
    required this.selectedTank,
    required this.selectedPump,
    required this.flowAnimValue,
    required this.blinkAnimValue,
    required this.pulseAnimValue,
    required this.tanks,
    required this.pipes,
    required this.pumps,
    required this.zones,
    required this.alerts,
    required this.hourly,
    required this.onBack,
    required this.onShowAlertTab,
    required this.onTabChanged,
    required this.onTankSelected,
    required this.onPumpSelected,
    required this.onToggleLive,
    required this.kpis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(flowAnimValue),
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: flowAnimValue, glow: pulseAnimValue),
              size: Size.infinite,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: AlwaysStoppedAnimation(flowAnimValue),
              builder: (_, __) => CustomPaint(
                painter: WavePainter(flowAnimValue),
                size: Size(MediaQuery.of(context).size.width, 100),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(0),
            builder: (_, __) => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.cyan.withOpacity(.04),
                      C.cyan.withOpacity(.09),
                      C.cyan.withOpacity(.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                WaterManagementHeader(
                  liveData: liveData,
                  critUnacked: alerts
                      .where((a) => a.level == AlertLevel.critical && !a.acked)
                      .length,
                  onBack: onBack,
                  onToggleLive: onToggleLive,
                  onShowCritical: onShowAlertTab,
                  blinkAnim: AlwaysStoppedAnimation(blinkAnimValue),
                ),
                WaterManagementKpiStrip(items: kpis),
                WaterManagementTabBar(
                  selectedTab: tab,
                  totalUnacked: alerts.where((a) => !a.acked).length,
                  criticalUnacked: alerts
                      .where((a) => a.level == AlertLevel.critical && !a.acked)
                      .length,
                  onTabChanged: onTabChanged,
                ),
                Expanded(
                  child: WaterManagementTabBody(
                    tab: tab,
                    liveData: liveData,
                    tanks: tanks,
                    pipes: pipes,
                    pumps: pumps,
                    zones: zones,
                    alerts: alerts,
                    hourly: hourly,
                    selectedTank: selectedTank,
                    selectedPump: selectedPump,
                    flowAnimValue: flowAnimValue,
                    blinkAnimValue: blinkAnimValue,
                    pulseAnimValue: pulseAnimValue,
                    onTabChange: onTabChanged,
                    onTankSelect: onTankSelected,
                    onPumpSelect: onPumpSelected,
                    onLiveDataToggle: (value) {},
                    onShowAlertTab: onShowAlertTab,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
