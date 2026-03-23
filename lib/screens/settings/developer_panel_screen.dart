import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/developer_panel_data_model.dart';
import 'package:urban_os/widgets/developer_panel/developer_header.dart';
import 'package:urban_os/widgets/developer_panel/developer_tab_bar.dart';
import 'package:urban_os/widgets/developer_panel/health_bar.dart';
import 'package:urban_os/widgets/developer_panel/logs_view.dart';
import 'package:urban_os/widgets/developer_panel/matric_view.dart';
import 'package:urban_os/widgets/developer_panel/system_view.dart';

// ─────────────────────────────────────────
//  COLOR PALETTE (UrbanOS — Developer Panel)
// ─────────────────────────────────────────
typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class DeveloperPanelScreen extends StatefulWidget {
  const DeveloperPanelScreen({super.key});

  @override
  State<DeveloperPanelScreen> createState() => _DeveloperPanelScreenState();
}

class _DeveloperPanelScreenState extends State<DeveloperPanelScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<DebugLog> _logs;
  late List<PerformanceMetric> _metrics;
  late SystemInfo _sysInfo;

  String _logFilter = 'ALL';
  int _selectedTab = 0;

  late StreamController<int> _logStreamCtrl;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _dataFlowCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _logs = buildDebugLogs()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _metrics = buildMetrics();
    _sysInfo = buildSystemInfo();
    _logStreamCtrl = StreamController.broadcast();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _dataFlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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

  List<DebugLog> get _filteredLogs => _logs.where((log) {
    if (_logFilter == 'ALL') return true;
    return log.level.label == _logFilter;
  }).toList();

  int get _errorCount => _logs.where((l) => l.level == LogLevel.error).length;
  int get _warningCount =>
      _logs.where((l) => l.level == LogLevel.warning).length;
  int get _infoCount => _logs.where((l) => l.level == LogLevel.info).length;

  SystemHealthStatus get _healthStatus {
    final errPercent = (_errorCount / _logs.length * 100);
    if (errPercent > 30) return SystemHealthStatus.critical;
    if (errPercent > 20) return SystemHealthStatus.poor;
    if (errPercent > 10) return SystemHealthStatus.fair;
    if (errPercent > 5) return SystemHealthStatus.good;
    return SystemHealthStatus.excellent;
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _dataFlowCtrl.dispose();
    _entranceCtrl.dispose();
    _logStreamCtrl.close();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -0.2),
                  radius: 1.3,
                  colors: [C.cyan.withOpacity(0.04), C.bg],
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
                      C.cyan.withOpacity(0.04),
                      C.cyan.withOpacity(0.12),
                      C.cyan.withOpacity(0.04),
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
                    DeveloperHeader(glowController: _glowCtrl),
                    HealthBar(
                      healthStatus: _healthStatus,
                      errorCount: _errorCount,
                      totalLogs: _logs.length,
                    ),
                    DeveloperTabBar(
                      selectedTab: _selectedTab,
                      logsCount: _filteredLogs.length,
                      metricsCount: _metrics.length,
                      systemCount: 7,
                      onTabChanged: (index) {
                        setState(() => _selectedTab = index);
                      },
                    ),
                    Expanded(
                      child: _selectedTab == 0
                          ? LogsView(
                              logs: _logs,
                              filteredLogs: _filteredLogs,
                              errorCount: _errorCount,
                              warningCount: _warningCount,
                              infoCount: _infoCount,
                              scrollController: _scrollCtrl,
                            )
                          : _selectedTab == 1
                          ? MetricsView(metrics: _metrics)
                          : SystemView(sysInfo: _sysInfo),
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
