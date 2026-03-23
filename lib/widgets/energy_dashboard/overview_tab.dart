import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/widgets/energy_dashboard/alert_preview_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/energy_mix_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/hourly_chart_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/power_balance_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/source_quick_view_panel.dart';
import 'package:urban_os/widgets/energy_dashboard/zone_summary.dart';

class OverviewTab extends StatefulWidget {
  final ScrollController scrollController;

  // Animated controllers and data for children
  final double totalGeneration;
  final double totalConsumption;
  final double gridLoadPct;
  final List<EnergySourceModel> sources;
  final List<PowerZone> zones;
  final List<EnergyAlert> alerts;
  final Animation<double> glowAnimation;
  final Animation<double> blinkAnimation;
  final List<HourlyData> hourlyData;
  final int unackAlerts;
  final void Function(EnergyAlert) onAck;

  const OverviewTab({
    super.key,
    required this.scrollController,
    required this.totalGeneration,
    required this.totalConsumption,
    required this.gridLoadPct,
    required this.sources,
    required this.zones,
    required this.alerts,
    required this.glowAnimation,
    required this.blinkAnimation,
    required this.hourlyData,
    required this.unackAlerts,
    required this.onAck,
  });

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  String _zoneSort = 'load';
  int _selectedZone = -1;

  void _onSortChanged(String key) {
    setState(() {
      _zoneSort = key;
    });
  }

  void _onZoneSelected(int index) {
    setState(() {
      _selectedZone = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Power balance + Energy mix row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: PowerBalancePanel(
                  totalGeneration: widget.totalGeneration,
                  totalConsumption: widget.totalConsumption,
                  gridLoadPct: widget.gridLoadPct,
                  glowAnimation: widget.glowAnimation,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: EnergyMixPanel(
                  sources: widget.sources,
                  totalGeneration: widget.totalGeneration,
                  glowAnimation: widget.glowAnimation,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 24h load chart
          HourlyChartPanel(
            hourlyData: widget.hourlyData,
            glowAnimation: widget.glowAnimation,
          ),
          const SizedBox(height: 12),
          // Zone summary cards
          ZoneSummary(
            zones: widget.zones,
            glowAnimation: widget.glowAnimation,
            blinkAnimation: widget.blinkAnimation,
            zoneSort: _zoneSort,
            selectedZone: _selectedZone,
            onSortChanged: _onSortChanged,
            onZoneSelected: _onZoneSelected,
          ),

          const SizedBox(height: 12),
          // Source quick view
          SourceQuickViewPanel(
            sources: widget.sources,
            glowAnimation: widget.glowAnimation,
          ),
          const SizedBox(height: 12),
          // Recent alerts preview
          AlertPreviewPanel(
            alerts: widget.alerts,
            unackAlerts: widget.unackAlerts,
            blinkAnimation: widget.blinkAnimation,
            onAck: widget.onAck,
          ),
        ],
      ),
    );
  }
}
