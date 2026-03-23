import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/traffic_dashboard_data_model.dart';
import 'package:urban_os/widgets/traffic_dashboard/hero_strip.dart';
import 'package:urban_os/widgets/traffic_dashboard/scan_line_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/header.dart';
import 'package:urban_os/widgets/traffic_dashboard/grid_overlay.dart';
import 'package:urban_os/widgets/traffic_dashboard/bg_painter.dart';
import 'package:urban_os/widgets/traffic_dashboard/tab_bar.dart';
import 'package:urban_os/widgets/traffic_dashboard/traffic_tabs.dart';

// ─────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────
typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class TrafficDashboardScreen extends StatefulWidget {
  const TrafficDashboardScreen({super.key});
  @override
  State<TrafficDashboardScreen> createState() => _TrafficDashboardState();
}

class _TrafficDashboardState extends State<TrafficDashboardScreen>
    with TickerProviderStateMixin {
  // Data
  late List<TrafficLight> _lights;
  late List<TrafficIncident> _incidents;
  int _selectedRoadIdx = 0;
  int _selectedTab = 0; // 0=Overview 1=Roads 2=Signals 3=Incidents 4=Parking

  // Live simulation
  final _rng = Random();
  late List<LiveVehicle> _vehicles;
  final Map<String, double> _liveStats = {};

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _vehicleCtrl;
  late AnimationController _signalCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _chartDrawCtrl;
  late AnimationController _flowCtrl;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _bodyFade;
  late Animation<Offset> _bodySlide;

  @override
  void initState() {
    super.initState();
    _lights = buildLights();
    _incidents = buildIncidents();
    _initVehicles();
    _initLiveStats();
    _setupControllers();
    _vehicleCtrl.addListener(_tickSimulation);
    _signalCtrl.addListener(_tickSignals);
    _entranceCtrl.forward();
  }

  void _initVehicles() {
    _vehicles = List.generate(
      20,
      (i) => LiveVehicle(
        progress: _rng.nextDouble(),
        laneIdx: i % 6,
        color: [
          C.cyan,
          C.teal,
          C.white,
          C.amber,
        ][i % 4].withOpacity(.65 + _rng.nextDouble() * .25),
        speed: .0005 + _rng.nextDouble() * .0008,
      ),
    );
  }

  void _initLiveStats() {
    _liveStats['vehicles'] = 1240;
    _liveStats['speed'] = 32;
    _liveStats['congestion'] = 72;
    _liveStats['incidents'] = 4;
  }

  void _tickSimulation() {
    if (!mounted) return;
    setState(() {
      for (final v in _vehicles) {
        v.progress += v.speed;
        if (v.progress > 1) v.progress = 0;
      }
      // Drift live stats slightly
      if (_vehicleCtrl.value < 0.02) {
        _liveStats['vehicles'] =
            ((_liveStats['vehicles']! + (_rng.nextDouble() - .5) * 20)).clamp(
              800,
              1500,
            );
        _liveStats['speed'] =
            ((_liveStats['speed']! + (_rng.nextDouble() - .5) * 2)).clamp(
              10,
              75,
            );
        _liveStats['congestion'] =
            ((_liveStats['congestion']! + (_rng.nextDouble() - .5) * 3)).clamp(
              20,
              98,
            );
      }
    });
  }

  void _tickSignals() {
    if (!mounted) return;
    if (_signalCtrl.value < 0.015) {
      setState(() {
        for (final tl in _lights) {
          tl.phaseTimer = (tl.phaseTimer - 1).clamp(0, tl.cycleTime);
          if (tl.phaseTimer == 0) {
            _advancePhase(tl);
          }
        }
      });
    }
  }

  void _advancePhase(TrafficLight tl) {
    switch (tl.phase) {
      case 'GREEN':
        tl.phase = 'YELLOW';
        tl.phaseTimer = 5;
        break;
      case 'YELLOW':
        tl.phase = 'RED';
        tl.phaseTimer = tl.cycleTime ~/ 2;
        break;
      case 'RED':
        tl.phase = 'GREEN';
        tl.phaseTimer = tl.cycleTime ~/ 2;
        break;
    }
  }

  void _setupControllers() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _vehicleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _signalCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _chartDrawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _headerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _headerSlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, -.5), end: Offset.zero));
    _bodyFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _bodySlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, .1), end: Offset.zero));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _vehicleCtrl.dispose();
    _signalCtrl.dispose();
    _flowCtrl.dispose();
    _entranceCtrl.dispose();
    _chartDrawCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          CustomPaint(
            painter: BgPainter(anim: _bgCtrl),
            size: Size.infinite,
          ),
          Positioned.fill(child: GridOverlay(anim: _glowCtrl)),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: ScanlinePainter()),
            ),
          ),
          // Scan beam
          AnimatedBuilder(
            animation: _scanCtrl,
            builder: (_, __) => Positioned(
              top: _scanCtrl.value * size.height - 1,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      kAccent.withOpacity(.04),
                      kAccent.withOpacity(.08),
                      kAccent.withOpacity(.04),
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
                // Header
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Header(
                      blinkCtrl: _blinkCtrl,
                      incidents: _incidents.where((i) => i.isActive).length,
                    ),
                  ),
                ),
                // Hero strip
                FadeTransition(
                  opacity: _headerFade,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _glowCtrl,
                      _blinkCtrl,
                      _vehicleCtrl,
                    ]),
                    builder: (_, __) => HeroStrip(
                      liveStats: _liveStats,
                      glowT: _glowCtrl.value,
                      blinkT: _blinkCtrl.value,
                    ),
                  ),
                ),
                // Tab bar
                FadeTransition(
                  opacity: _bodyFade,
                  child: TabBarWidget(
                    selected: _selectedTab,
                    onTap: (i) {
                      setState(() => _selectedTab = i);
                      if (i == 0) _chartDrawCtrl.forward(from: 0);
                    },
                  ),
                ),
                // Content
                Expanded(
                  child: FadeTransition(
                    opacity: _bodyFade,
                    child: SlideTransition(
                      position: _bodySlide,
                      child: TrafficTabs(
                        selectedTab: _selectedTab,
                        roads: roads,
                        vehicles: _vehicles,
                        liveStats: _liveStats,
                        glowCtrl: _glowCtrl,
                        blinkCtrl: _blinkCtrl,
                        pulseCtrl: _pulseCtrl,
                        flowCtrl: _flowCtrl,
                        chartDrawCtrl: _chartDrawCtrl,
                        selectedRoadIdx: _selectedRoadIdx,
                        onSelectRoad: (i) =>
                            setState(() => _selectedRoadIdx = i),
                        lights: _lights,
                        incidents: _incidents,
                        zones: parking,
                        onToggleAdaptive: (tl) =>
                            setState(() => tl.isAdaptive = !tl.isAdaptive),
                        onForcePhase: (tl, phase) => setState(() {
                          tl.phase = phase;
                          tl.phaseTimer = 30;
                        }),
                        onResolve: (inc) =>
                            setState(() => inc.isActive = false),
                      ),
                    ),
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
