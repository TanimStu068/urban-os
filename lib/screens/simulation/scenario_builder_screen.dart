import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/scenario_builder_data_model.dart';
import 'package:urban_os/widgets/scenario_builder/scenario_control_bar.dart';
import 'package:urban_os/widgets/scenario_builder/scenario_header.dart';
import 'package:urban_os/widgets/scenario_builder/scenario_list.dart';
import 'package:urban_os/widgets/scenario_builder/stat_bar.dart';

typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class ScenarioBuilderScreen extends StatefulWidget {
  const ScenarioBuilderScreen({super.key});

  @override
  State<ScenarioBuilderScreen> createState() => _ScenarioBuilderScreenState();
}

class _ScenarioBuilderScreenState extends State<ScenarioBuilderScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<Scenario> _scenarios;

  String _filterStatus = 'ALL';
  String _sortBy = 'RECENT';
  bool _showBuilder = false;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _shimmerCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _expandedScenarios = <String>{};

  @override
  void initState() {
    super.initState();
    _scenarios = buildScenarios();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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

  List<Scenario> get _filteredScenarios =>
      _scenarios.where((s) {
        if (_filterStatus != 'ALL' && s.status.label != _filterStatus)
          return false;
        return true;
      }).toList()..sort((a, b) {
        if (_sortBy == 'RECENT') {
          return b.createdAt.compareTo(a.createdAt);
        } else if (_sortBy == 'COMPLEXITY') {
          return a.complexity.stepCount.compareTo(b.complexity.stepCount);
        }
        return 0;
      });

  int get _activeScenarios =>
      _scenarios.where((s) => s.status == ScenarioStatus.active).length;
  int get _totalSteps => _scenarios.fold(0, (sum, s) => sum + s.steps.length);
  double get _avgSuccess => _scenarios.isEmpty
      ? 0
      : _scenarios.fold(0, (sum, s) => sum + s.successMetrics) /
            _scenarios.length;

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _shimmerCtrl.dispose();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.4, -0.3),
                  radius: 1.2,
                  colors: [C.teal.withOpacity(0.05), C.bg],
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
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.teal.withOpacity(0.04),
                      C.teal.withOpacity(0.10),
                      C.teal.withOpacity(0.04),
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
                    ScenarioHeader(
                      glowAnimation: _glowCtrl,
                      onBack: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    StatsBar(
                      activeScenarios: _activeScenarios,
                      totalScenarios: _scenarios.length,
                      totalSteps: _totalSteps,
                      avgSuccess: _avgSuccess,
                    ),
                    ControlBar(
                      filterStatus: _filterStatus,
                      sortBy: _sortBy,
                      showBuilder: _showBuilder,
                      onFilterChanged: (newStatus) {
                        setState(() => _filterStatus = newStatus);
                      },
                      onSortChanged: (newSort) {
                        setState(() => _sortBy = newSort);
                      },
                      onShowBuilderChanged: (newShow) {
                        setState(() => _showBuilder = newShow);
                      },
                    ),
                    Expanded(
                      child: ScenarioList(
                        filteredScenarios: _filteredScenarios,
                        expandedScenarios: _expandedScenarios,
                        scrollController: _scrollCtrl,
                        glowCtrl: _glowCtrl,
                        onToggleScenario: (scenarioId) {
                          setState(() {
                            if (_expandedScenarios.contains(scenarioId)) {
                              _expandedScenarios.remove(scenarioId);
                            } else {
                              _expandedScenarios.add(scenarioId);
                            }
                          });
                        },
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
