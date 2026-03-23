import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/fire_monitoring_data_model.dart';
import 'package:urban_os/widgets/fire_monitoring/equivment_view.dart';
import 'package:urban_os/widgets/fire_monitoring/fire_header.dart';
import 'package:urban_os/widgets/fire_monitoring/zone_control_bar.dart';
import 'package:urban_os/widgets/fire_monitoring/zone_stats_bar.dart';
import 'package:urban_os/widgets/fire_monitoring/zone_view.dart';

typedef C = AppColors;

const kAccent = C.red;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class FireMonitoringScreen extends StatefulWidget {
  const FireMonitoringScreen({super.key});

  @override
  State<FireMonitoringScreen> createState() => _FireMonitoringScreenState();
}

class _FireMonitoringScreenState extends State<FireMonitoringScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<FireZone> _zones;
  late List<FireEquipment> _equipment;

  String _viewFilter = 'CRITICAL';
  bool _showHeatmap = true;
  bool _showEquipment = false;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _heatCtrl;
  late AnimationController _flameCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _expandedZones = <String>{};

  @override
  void initState() {
    super.initState();
    _zones = buildZones();
    _equipment = buildEquipment();
    _initAnims();
    _entranceCtrl.forward();
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
    _heatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _flameCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
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

  List<FireZone> get _filteredZones => _zones.where((zone) {
    if (_viewFilter == 'ACTIVE') {
      return zone.status != ZoneStatus.clear;
    } else if (_viewFilter == 'CRITICAL') {
      return zone.status == ZoneStatus.fire ||
          zone.status == ZoneStatus.hotspot;
    }
    return true;
  }).toList();

  int get _fireZones => _zones.where((z) => z.status == ZoneStatus.fire).length;
  int get _peopleAtRisk => _zones.fold(0, (sum, z) => sum + z.peopleInZone);
  int get _equipmentActive =>
      _equipment.where((e) => e.status == EquipmentStatus.active).length;
  double get _avgTemp => _zones.isEmpty
      ? 0
      : _zones.fold(0.0, (sum, z) => sum + z.temperature) / _zones.length;

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _heatCtrl.dispose();
    _flameCtrl.dispose();
    _scanCtrl.dispose();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.3, -0.5),
                  radius: 1.4,
                  colors: [C.red.withOpacity(0.06), C.bg],
                ),
              ),
            ),
          ),
          // Heatmap glow
          AnimatedBuilder(
            animation: _heatCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.2, 0.1),
                  radius: 1.2,
                  colors: [
                    C.orange.withOpacity(0.03 + _heatCtrl.value * 0.02),
                    Colors.transparent,
                  ],
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
                height: 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.red.withOpacity(0.08),
                      C.red.withOpacity(0.14),
                      C.red.withOpacity(0.08),
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
                    FireHeader(
                      contextRef: context,
                      glowCtrl: _glowCtrl,
                      flameCtrl: _flameCtrl,
                      fireZones: _fireZones,
                      avgTemp: _avgTemp,
                    ),
                    ZoneStatsBar(
                      fireZones: _fireZones,
                      peopleAtRisk: _peopleAtRisk,
                      equipmentActive: _equipmentActive,
                      avgTemp: _avgTemp,
                    ),
                    ZoneControlBar(
                      viewFilter: _viewFilter,
                      showHeatmap: _showHeatmap,
                      showEquipment: _showEquipment,
                      onViewFilterChanged: (val) =>
                          setState(() => _viewFilter = val),
                      onShowHeatmapChanged: (val) =>
                          setState(() => _showHeatmap = val),
                      onShowEquipmentChanged: (val) =>
                          setState(() => _showEquipment = val),
                    ),
                    Expanded(child: _buildMainView()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    if (_showEquipment) {
      return EquipmentView(scrollCtrl: _scrollCtrl, equipmentList: _equipment);
    } else {
      return ZoneView(
        scrollCtrl: _scrollCtrl,
        filteredZones: _filteredZones,
        expandedZones: _expandedZones,
        glowCtrl: _glowCtrl,
        onToggleExpanded: (id) {
          setState(() {
            if (_expandedZones.contains(id)) {
              _expandedZones.remove(id);
            } else {
              _expandedZones.add(id);
            }
          });
        },
      );
    }
  }
}
