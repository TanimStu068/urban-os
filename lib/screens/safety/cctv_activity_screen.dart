import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/cctv_activity_data_model.dart';
import 'package:urban_os/widgets/cctv_activity/camera_controll_bar.dart';
import 'package:urban_os/widgets/cctv_activity/camera_header.dart';
import 'package:urban_os/widgets/cctv_activity/camera_stat_bar.dart';

typedef C = AppColors;

const kAccent = C.teal;

//  SCREEN
class CCTVActivityScreen extends StatefulWidget {
  const CCTVActivityScreen({super.key});

  @override
  State<CCTVActivityScreen> createState() => _CCTVActivityState();
}

class _CCTVActivityState extends State<CCTVActivityScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<CCTVCamera> _cameras;
  late List<CCTVIncident> _incidents;

  ViewMode _viewMode = ViewMode.grid;
  String _searchQuery = '';
  String? _selectedZone;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _recordCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _cameras = buildCameras();
    _incidents = buildIncidents();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _recordCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));
  }

  int get _onlineCameras =>
      _cameras.where((c) => c.status == CameraStatus.online).length;
  int get _unacknowledgedIncidents =>
      _incidents.where((i) => !i.acknowledged).length;

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _recordCtrl.dispose();
    _entranceCtrl.dispose();
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
          // Background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -0.3),
                  radius: 1.2,
                  colors: [C.red.withOpacity(0.04), C.bg],
                ),
              ),
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
                      C.red.withOpacity(0.04),
                      C.red.withOpacity(0.10),
                      C.red.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    CameraHeader(
                      glowAnimation: _glowCtrl,
                      onlineCameras: _onlineCameras,
                      totalCameras: _cameras.length,
                      unacknowledgedIncidents: _unacknowledgedIncidents,
                      onBack: () => Navigator.maybePop(context),
                    ),
                    CameraStatsBar(
                      onlineCameras: _onlineCameras,
                      recordingCount: _cameras
                          .where((c) => c.recording != RecordingMode.off)
                          .length,
                      alertsCount: _cameras.where((c) => c.hasAlert).length,
                      peopleCount: _cameras.fold(
                        0,
                        (sum, c) => sum + c.peopleCount,
                      ),
                    ),
                    CameraControlBar(
                      searchQuery: _searchQuery,
                      selectedZone: _selectedZone,
                      viewMode: _viewMode,
                      onSearchChanged: (val) =>
                          setState(() => _searchQuery = val),
                      onZoneSelected: (zone) =>
                          setState(() => _selectedZone = zone),
                      onViewModeChanged: (mode) =>
                          setState(() => _viewMode = mode),
                    ),
                    Expanded(
                      child: CameraControlBar(
                        searchQuery: _searchQuery,
                        selectedZone: _selectedZone,
                        viewMode: _viewMode,
                        onSearchChanged: (val) =>
                            setState(() => _searchQuery = val),
                        onZoneSelected: (zone) =>
                            setState(() => _selectedZone = zone),
                        onViewModeChanged: (mode) =>
                            setState(() => _viewMode = mode),
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

  @override
  void deactivate() {
    super.deactivate();
  }
}
