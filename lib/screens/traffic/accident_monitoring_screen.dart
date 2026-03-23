import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/accident_monitoing_body.dart';
import 'package:urban_os/widgets/accident_monitoring/accident_monitoring_header.dart';
import 'package:urban_os/widgets/accident_monitoring/alert_banner.dart';
import 'package:urban_os/widgets/accident_monitoring/detail_panel.dart';
import 'package:urban_os/widgets/accident_monitoring/filter_tab.dart';
import 'package:urban_os/widgets/accident_monitoring/summary_strip.dart';
import 'package:urban_os/widgets/accident_monitoring/bg_painter.dart';

// ─────────────────────────────────────────
//  COLORS  (UrbanOS palette)
// ─────────────────────────────────────────
typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class AccidentMonitoringScreen extends StatefulWidget {
  const AccidentMonitoringScreen({super.key});

  @override
  State<AccidentMonitoringScreen> createState() => _AccidentMonitoringState();
}

class _AccidentMonitoringState extends State<AccidentMonitoringScreen>
    with TickerProviderStateMixin {
  late List<AccidentEvent> _accidents;
  int _selectedIdx = 0;
  int _filterTab = 0; // 0=ALL 1=ACTIVE 2=CRITICAL 3=CLEARED
  int _detailTab = 0; // 0=OVERVIEW 1=TIMELINE 2=RESPONSE 3=IMPACT

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _radarCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _waveCtrl; // for accident pulse rings on map
  late AnimationController _shimmerCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _accidents = buildAccidents();

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
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmerCtrl = AnimationController(
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
    ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _radarCtrl.dispose();
    _waveCtrl.dispose();
    _shimmerCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  AccidentEvent get _selected => _accidents[_selectedIdx];

  List<AccidentEvent> get _filtered {
    switch (_filterTab) {
      case 1:
        return _accidents
            .where(
              (a) =>
                  a.severity != AccidentSeverity.cleared &&
                  a.responseStatus != ResponseStatus.closed,
            )
            .toList();
      case 2:
        return _accidents
            .where(
              (a) =>
                  a.severity == AccidentSeverity.critical ||
                  a.severity == AccidentSeverity.high,
            )
            .toList();
      case 3:
        return _accidents
            .where(
              (a) =>
                  a.severity == AccidentSeverity.cleared ||
                  a.responseStatus == ResponseStatus.closed,
            )
            .toList();
      default:
        return _accidents;
    }
  }

  int get _activeCount => _accidents
      .where(
        (a) =>
            a.severity != AccidentSeverity.cleared &&
            a.responseStatus != ResponseStatus.closed,
      )
      .length;
  int get _criticalCount =>
      _accidents.where((a) => a.severity == AccidentSeverity.critical).length;
  int get _totalInjuries =>
      _accidents.fold(0, (s, a) => s + a.injuriesReported);
  int get _totalUnits =>
      _accidents.fold(0, (s, a) => s + a.dispatchedUnits.length);

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Animated BG
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: _bgCtrl.value),
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
                      C.red.withOpacity(0.04),
                      C.red.withOpacity(0.08),
                      C.red.withOpacity(0.04),
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
                    const AccidentMonitorHeader(),
                    AlertBanner(
                      blinkCtrl: _blinkCtrl,
                      glowCtrl: _glowCtrl,
                      criticalCount: _criticalCount,
                      message:
                          'CRITICAL ACCIDENTS DETECTED — IMMEDIATE ACTION REQUIRED',
                    ),
                    SummaryStrip(
                      glowCtrl: _glowCtrl,
                      totalToday: _accidents.length,
                      activeCount: _activeCount,
                      criticalCount: _criticalCount,
                      totalInjuries: _totalInjuries,
                      totalUnits: _totalUnits,
                    ),
                    FilterTabs(
                      selectedIndex: _filterTab,
                      onTabSelected: (index) {
                        setState(() {
                          _filterTab = index;
                        });
                      },
                    ),
                    // Inside your build method, replacing _buildBody()
                    Expanded(
                      child: AccidentMonitoringBody(
                        accidents: _accidents,
                        filtered: _filtered,
                        selectedIdx: _selectedIdx,
                        glowValue: _glowCtrl.value,
                        blinkValue: _blinkCtrl.value,
                        onSelectIncident: (newIndex) {
                          setState(() {
                            _selectedIdx = newIndex;
                          });
                        },
                        buildDetailPanel: () => DetailPanel(
                          accident: _selected,
                          allAccidents: _accidents,
                          selectedTab: _detailTab,
                          onTabChanged: (idx) {
                            setState(() {
                              _detailTab = idx;
                            });
                          },
                          glowCtrl: _glowCtrl,
                          onCloseIncident: () {
                            setState(() {
                              _selected.responseStatus = ResponseStatus.closed;
                              _selected.severity = AccidentSeverity.cleared;
                            });
                          },
                        ),
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
