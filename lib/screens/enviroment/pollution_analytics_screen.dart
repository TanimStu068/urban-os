import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/pollution_analysis_data_model.dart';
import 'package:urban_os/widgets/pollution_analytics/district_comparison.dart';
import 'package:urban_os/widgets/pollution_analytics/health_score_bar.dart';
import 'package:urban_os/widgets/pollution_analytics/pollutionTrendPanel.dart';
import 'package:urban_os/widgets/pollution_analytics/pollutant_selector.dart';
import 'package:urban_os/widgets/pollution_analytics/pollution_analytics_header.dart';
import 'package:urban_os/widgets/pollution_analytics/source_break_down_panel.dart';
import 'package:urban_os/widgets/pollution_analytics/time_range_selector.dart';

typedef C = AppColors;

const kAccent = C.teal;

//  SCREEN
class PollutionAnalyticsScreen extends StatefulWidget {
  const PollutionAnalyticsScreen({super.key});

  @override
  State<PollutionAnalyticsScreen> createState() => _PollutionAnalyticsState();
}

class _PollutionAnalyticsState extends State<PollutionAnalyticsScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<PollutionDataPoint> _hourlyData;
  late List<DistrictPollutionData> _districtData;
  late List<PollutionSource> _sources;

  PollutantType _selectedPollutant = PollutantType.pm25;
  bool _liveMode = true;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _liveCtrl;
  late AnimationController _barAnimCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  // ── derived ──
  double get _avgPollutant {
    final readings = _hourlyData;
    double sum = 0;
    for (final r in readings) {
      sum += _getPollutantValue(r, _selectedPollutant);
    }
    return sum / readings.length;
  }

  double get _maxPollutant {
    double max = 0;
    for (final r in _hourlyData) {
      final val = _getPollutantValue(r, _selectedPollutant);
      if (val > max) max = val;
    }
    return max;
  }

  double get _healthScore {
    final avg = _avgPollutant;
    final limit = _selectedPollutant.safeLimit;
    return (1 - (avg / (limit * 2))).clamp(0, 1) * 100;
  }

  double _getPollutantValue(PollutionDataPoint data, PollutantType type) {
    switch (type) {
      case PollutantType.pm25:
        return data.pm25;
      case PollutantType.pm10:
        return data.pm10;
      case PollutantType.no2:
        return data.no2;
      case PollutantType.o3:
        return data.o3;
      case PollutantType.co:
        return data.co;
      case PollutantType.so2:
        return data.so2;
    }
  }

  @override
  void initState() {
    super.initState();
    _hourlyData = buildHourlyData();
    _districtData = buildDistrictData();
    _sources = buildSources();
    _initAnims();
    _entranceCtrl.forward();
    _barAnimCtrl.forward();
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
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _barAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));

    _liveCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && _liveMode) _tickLive();
    });
  }

  void _tickLive() {
    if (!mounted || !_liveMode) return;
    setState(() {});
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _liveCtrl.dispose();
    _barAnimCtrl.dispose();
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
                color: C.bg,
                gradient: RadialGradient(
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -0.3),
                  radius: 1.2,
                  colors: [C.teal.withOpacity(0.04), C.bg],
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
                      C.orange.withOpacity(0.04),
                      C.orange.withOpacity(0.10),
                      C.orange.withOpacity(0.04),
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
                    PollutionAnalyticsHeader(
                      districtCount: _districtData.length,
                      liveMode: _liveMode,
                      glowCtrl: _glowCtrl,
                      onBack: () => Navigator.maybePop(context),
                      onToggleLive: () =>
                          setState(() => _liveMode = !_liveMode),
                    ),
                    HealthScoreBar(
                      healthScore: _healthScore,
                      avgPollutant: _avgPollutant,
                      maxPollutant: _maxPollutant,
                      selectedPollutant: _selectedPollutant,
                      glowCtrl: _glowCtrl,
                      barAnimCtrl: _barAnimCtrl,
                    ),
                    PollutantSelector(
                      selectedPollutant: _selectedPollutant,
                      barAnimCtrl: _barAnimCtrl,
                      onChanged: (p) {
                        setState(() => _selectedPollutant = p);
                      },
                    ),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() => SingleChildScrollView(
    controller: _scrollCtrl,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PollutionTrendPanel(
          selectedPollutant: _selectedPollutant,
          hourlyData: _hourlyData,
          glowCtrl: _glowCtrl,
          barAnimCtrl: _barAnimCtrl,
        ),
        const SizedBox(height: 12),
        SourceBreakdownPanel(sources: _sources, glowCtrl: _glowCtrl),
        const SizedBox(height: 12),
        DistrictComparisonPanel(
          districts: _districtData,
          selectedPollutant: _selectedPollutant,
          glowCtrl: _glowCtrl,
          barAnimCtrl: _barAnimCtrl,
        ),
        const SizedBox(height: 12),
        TimeRangeSelector(),
      ],
    ),
  );
}
