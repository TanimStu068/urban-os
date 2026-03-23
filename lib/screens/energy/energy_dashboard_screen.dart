import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/energy_dashboard_data_model.dart';
import 'package:urban_os/providers/infrastructure_provider.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/widgets/energy_dashboard/alerts_tabs.dart';
import 'package:urban_os/widgets/energy_dashboard/grid_tab.dart';
import 'package:urban_os/widgets/energy_dashboard/overview_tab.dart';
import 'package:urban_os/widgets/energy_dashboard/bg_painter.dart';
import 'package:urban_os/widgets/energy_dashboard/dashboard_tabbar.dart';
import 'package:urban_os/widgets/energy_dashboard/energy_dashboard_header.dart';
import 'package:urban_os/widgets/energy_dashboard/sources_tab.dart';
import 'package:urban_os/widgets/energy_dashboard/top_kpi_strip.dart';

// ─────────────────────────────────────────
//  COLOR PALETTE  (UrbanOS — Energy Theme)
// ─────────────────────────────────────────t
typedef C = AppColors;

const kAccent = C.amber;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class EnergyDashboardScreen extends StatefulWidget {
  const EnergyDashboardScreen({super.key});
  @override
  State<EnergyDashboardScreen> createState() => _EnergyDashboardState();
}

class _EnergyDashboardState extends State<EnergyDashboardScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<PowerZone> _zones;
  late List<EnergySourceModel> _sources;
  late List<EnergyAlert> _alerts;
  late List<HourlyData> _hourly;

  // ── ui state ──
  int _tab = 0; // 0=overview 1=grid 2=sources 3=alerts
  bool _liveUpdates = true;

  // ── derived totals ──
  double get _totalConsumption => _zones.fold(0.0, (s, z) => s + z.consumption);
  double get _totalGeneration =>
      _sources.where((s) => s.isActive).fold(0.0, (s, src) => s + src.output);
  double get _totalCapacity => _zones.fold(0.0, (s, z) => s + z.capacity);
  double get _gridLoadPct => _totalCapacity > 0
      ? (_totalConsumption / _totalCapacity * 100).clamp(0, 100)
      : 0;
  double get _renewablePct => _totalGeneration > 0
      ? (_sources
                    .where(
                      (s) =>
                          s.isActive &&
                          s.type != EnergySource.grid &&
                          s.type != EnergySource.generator,
                    )
                    .fold(0.0, (s, src) => s + src.output) /
                _totalGeneration *
                100)
            .clamp(0, 100)
      : 0;
  int get _criticalZones =>
      _zones.where((z) => z.status == ZoneStatus.critical).length;
  int get _unackAlerts => _alerts.where((a) => !a.acknowledged).length;

  // ── animations ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _flowCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    // Try to load zones and power data from providers
    try {
      final infraProvider = context.read<InfrastructureProvider>();
      final sensorProvider = context.read<SensorProvider>();
      _zones = _buildZonesFromProviders(infraProvider, sensorProvider);
    } catch (e) {
      // Providers not available, use mock zones
      _zones = buildZones();
    }
    _sources = buildSources();
    _alerts = buildAlerts();
    _hourly = buildHourly();
    _initAnims();
    _entranceCtrl.forward();
  }

  /// Build PowerZone objects from infrastructure and sensor providers
  List<PowerZone> _buildZonesFromProviders(
    InfrastructureProvider infraProvider,
    SensorProvider sensorProvider,
  ) {
    final zones = <PowerZone>[];

    // Create zones from infrastructure zones
    for (final zone in infraProvider.zones) {
      // Find power consumption sensors for this zone
      final powerSensors = sensorProvider.sensors
          .where(
            (s) =>
                s.type == SensorType.powerConsumption &&
                s.districtId == zone.districtId,
          )
          .toList();

      // Calculate total consumption from sensors
      double totalConsumption = 0;
      for (final sensor in powerSensors) {
        if (sensor.latestReading != null) {
          totalConsumption += sensor.latestReading!.value;
        }
      }

      // Estimate capacity as 1.5x current consumption or 10000 default
      final capacity = totalConsumption > 0
          ? (totalConsumption * 1.5).clamp(5000, 15000).toDouble()
          : 10000.0;
      final loadPct = capacity > 0
          ? (totalConsumption / capacity * 100).clamp(0, 100).toDouble()
          : 0.0;

      zones.add(
        PowerZone(
          id: zone.id,
          name: zone.name.toUpperCase(),
          district: zone.districtId,
          consumption: totalConsumption,
          capacity: capacity,
          status: _calculateZoneStatus(loadPct),
          loadPct: loadPct,
          history: rndHistory(totalConsumption * 0.8, totalConsumption * 1.2),
        ),
      );
    }

    return zones.isNotEmpty ? zones : buildZones();
  }

  /// Determine zone status based on load percentage
  ZoneStatus _calculateZoneStatus(double loadPct) {
    if (loadPct >= 90) return ZoneStatus.critical;
    if (loadPct >= 80) return ZoneStatus.warning;
    return ZoneStatus.normal;
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _liveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.04), end: Offset.zero));

    // live data ticker
    _liveCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && _liveUpdates) {
        _tickLiveData();
      }
    });
  }

  void _tickLiveData() {
    if (!_liveUpdates || !mounted) return;
    setState(() {
      for (final z in _zones) {
        if (z.status == ZoneStatus.offline) continue;
        final delta = (_rnd.nextDouble() - 0.5) * 200;
        z.consumption = (z.consumption + delta).clamp(
          z.capacity * 0.4,
          z.capacity,
        );
        z.loadPct = z.consumption / z.capacity * 100;
        if (z.loadPct >= 95) {
          z.status = ZoneStatus.critical;
        } else if (z.loadPct >= 85) {
          z.status = ZoneStatus.warning;
        } else if (z.loadPct <= 60) {
          z.status = ZoneStatus.saving;
        } else {
          z.status = ZoneStatus.normal;
        }
      }
      for (final s in _sources) {
        if (!s.isActive) continue;
        final delta = (_rnd.nextDouble() - 0.5) * s.capacity * 0.03;
        s.output = (s.output + delta).clamp(0, s.capacity);
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _flowCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  BUILD ROOT
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: _bgCtrl.value, glow: _glowCtrl.value),
              size: Size.infinite,
            ),
          ),
          // Scan beam
          AnimatedBuilder(
            animation: _scanCtrl,
            builder: (_, __) => Positioned(
              top: _scanCtrl.value * size.height,
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.amber.withOpacity(0.04),
                      C.amber.withOpacity(0.09),
                      C.amber.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    EnergyDashboardHeader(
                      zonesCount: _zones.length,
                      activeSources: _sources.where((s) => s.isActive).length,
                      liveUpdates: _liveUpdates,
                      unackAlerts: _unackAlerts,
                      glowAnimation: _glowCtrl,
                      pulseAnimation: _pulseCtrl,
                      blinkAnimation: _blinkCtrl,
                      onBack: () => Navigator.maybePop(context),
                      onToggleLive: () =>
                          setState(() => _liveUpdates = !_liveUpdates),
                    ),
                    TopKpiStrip(
                      totalConsumption: _totalConsumption,
                      totalGeneration: _totalGeneration,
                      gridLoadPct: _gridLoadPct,
                      renewablePct: _renewablePct,
                      criticalZones: _criticalZones,
                      sources: _sources,
                      glowAnimation: _glowCtrl,
                      blinkAnimation: _blinkCtrl,
                    ),
                    DashboardTabBar(
                      selectedIndex: _tab,
                      unackAlerts: _unackAlerts,
                      onTabChanged: (index) {
                        setState(() {
                          _tab = index;
                        });
                      },
                    ),
                    Expanded(child: _buildTabContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TAB CONTENT
  // ─────────────────────────────────────────
  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: IndexedStack(
        key: ValueKey(_tab),
        index: _tab,
        children: [
          OverviewTab(
            scrollController: _scrollCtrl,
            totalGeneration: _totalGeneration,
            totalConsumption: _totalConsumption,
            gridLoadPct: _gridLoadPct,
            sources: _sources,
            zones: _zones,
            alerts: _alerts,
            glowAnimation: _glowCtrl,
            blinkAnimation: _blinkCtrl,
            hourlyData: _hourly,
            unackAlerts: _unackAlerts,
            onAck: (alert) {
              setState(() {
                alert.acknowledged = true;
              });
            },
          ),
          GridTab(
            zones: _zones,
            sources: _sources,
            flowAnimation: _flowCtrl,
            glowAnimation: _glowCtrl,
            blinkAnimation: _blinkCtrl,
          ),
          SourcesTab(
            sources: _sources,
            glowAnimation: _glowCtrl,
            blinkAnimation: _blinkCtrl,
            totalGeneration: _totalGeneration,
            renewablePct: _renewablePct,
          ),
          AlertsTab(
            alerts: _alerts,
            unackAlerts: _unackAlerts,
            blinkController: _blinkCtrl,
          ),
        ],
      ),
    );
  }
}
