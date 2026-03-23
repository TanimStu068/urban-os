import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/road_detail_data_model.dart';
import 'package:urban_os/widgets/road_detail/charts_card.dart';
import 'package:urban_os/widgets/road_detail/health_radar.dart';
import 'package:urban_os/widgets/road_detail/hero_kpi_row.dart';
import 'package:urban_os/widgets/road_detail/incident_card.dart';
import 'package:urban_os/widgets/road_detail/lane_analysis_card.dart';
import 'package:urban_os/widgets/road_detail/live_dot.dart';
import 'package:urban_os/widgets/road_detail/bg_painter.dart';
import 'package:urban_os/widgets/road_detail/recommendations_card.dart';
import 'package:urban_os/widgets/road_detail/road_detail_header.dart';
import 'package:urban_os/widgets/road_detail/road_topology_card.dart';
import 'package:urban_os/widgets/road_detail/section_nav_bar.dart';
import 'package:urban_os/widgets/road_detail/sensor_card.dart';
import 'package:urban_os/widgets/road_detail/speed_zone_card.dart';
import 'package:urban_os/widgets/road_detail/status_banner.dart';

typedef C = AppColors;

const kAccent = C.cyan;

//  SCREEN — no constructor parameter
class RoadDetailScreen extends StatefulWidget {
  const RoadDetailScreen({super.key});

  @override
  State<RoadDetailScreen> createState() => _RoadDetailScreenState();
}

// ignore_for_file: avoid_function_literals_in_foreach_calls
class _RoadDetailScreenState extends State<RoadDetailScreen>
    with TickerProviderStateMixin {
  // Direct reference to mock data — no widget.road needed
  final road = sampleRoad;

  int _activeSection = 0;

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _vehicleCtrl;
  late AnimationController _chartCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _laneCtrl;
  late AnimationController _radarCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _rng = Random();
  late List<LiveDot> _liveDots;

  final ScrollController _scrollCtrl = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _liveDots = List.generate(
      14,
      (i) => LiveDot(
        progress: _rng.nextDouble(),
        lane: i % road.lanes,
        color: [
          C.cyan,
          C.teal,
          C.white,
          C.amber,
        ][i % 4].withOpacity(0.6 + _rng.nextDouble() * 0.3),
        speed: 0.0006 + _rng.nextDouble() * 0.001,
        isReverse: i % 4 >= 2,
      ),
    );

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _vehicleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _chartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _laneCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    _vehicleCtrl.addListener(_tickVehicles);
    _entranceCtrl.forward();
  }

  void _tickVehicles() {
    if (!mounted) return;
    setState(() {
      for (final d in _liveDots) {
        d.progress += d.speed * (d.isReverse ? -1 : 1);
        if (d.progress > 1) d.progress = 0;
        if (d.progress < 0) d.progress = 1;
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _blinkCtrl.dispose();
    _vehicleCtrl.dispose();
    _chartCtrl.dispose();
    _entranceCtrl.dispose();
    _laneCtrl.dispose();
    _radarCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgGridPainter(t: _bgCtrl.value),
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
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      kAccent.withOpacity(0.06),
                      kAccent.withOpacity(0.12),
                      kAccent.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    RoadDetailHeader(
                      road: road,
                      blinkT: _blinkCtrl,
                      onBack: () => Navigator.pop(context),
                      onShare: () => print('Share tapped'),
                      onMore: () => print('More tapped'),
                    ),
                    StatusBanner(
                      road: road,
                      glowT: _glowCtrl,
                      blinkT: _blinkCtrl,
                    ),
                    SectionNavBar(
                      sections: sections,
                      sectionIcons: sectionIcons,
                      activeSection: _activeSection,
                      sectionKeys: _sectionKeys,
                      chartCtrl: _chartCtrl,
                      onSectionChanged: (i) =>
                          setState(() => _activeSection = i),
                    ),
                    Expanded(
                      child: ListView(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 40),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          HeroKpiRow(road: road, glowCtrl: _glowCtrl),
                          const SizedBox(height: 14),
                          Container(
                            key: _sectionKeys[0],
                            child: RoadTopologyCard(
                              road: road,
                              liveDots: _liveDots,
                              vehicleCtrl: _vehicleCtrl,
                              pulseCtrl: _pulseCtrl,
                              glowCtrl: _glowCtrl,
                              blinkCtrl: _blinkCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            key: _sectionKeys[1],
                            child: ChartsCard(
                              road: road,
                              chartCtrl: _chartCtrl,
                              glowCtrl: _glowCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            key: _sectionKeys[2],
                            child: LaneAnalysisCard(
                              road: road,
                              laneCtrl: _laneCtrl,
                              glowCtrl: _glowCtrl,
                              blinkCtrl: _blinkCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            key: _sectionKeys[3],
                            child: SensorsCard(
                              road: road,
                              glowCtrl: _glowCtrl,
                              blinkCtrl: _blinkCtrl,
                              pulseCtrl: _pulseCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          IncidentsCard(
                            road: road,
                            glowCtrl: _glowCtrl,
                            blinkCtrl: _blinkCtrl,
                          ),
                          const SizedBox(height: 14),
                          Container(
                            key: _sectionKeys[4],
                            child: SpeedZonesCard(
                              road: road,
                              glowCtrl: _glowCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          RecommendationsCard(
                            recommendations: getRecommendations(),
                          ),
                          const SizedBox(height: 14),
                          HealthRadarCard(
                            road: road,
                            radarCtrl: _radarCtrl,
                            glowCtrl: _glowCtrl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
