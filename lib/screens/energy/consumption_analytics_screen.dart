import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/consumption_analytics_data_model.dart';
import 'package:urban_os/widgets/consumption_analytics/bg_painter.dart';
import 'package:urban_os/widgets/consumption_analytics/chart_mode_bar.dart';
import 'package:urban_os/widgets/consumption_analytics/consumption_analytics_header.dart';
import 'package:urban_os/widgets/consumption_analytics/dashboard_body.dart';
import 'package:urban_os/widgets/consumption_analytics/kpi_strip.dart';
import 'package:urban_os/widgets/consumption_analytics/range_bar.dart';
import 'package:urban_os/widgets/consumption_analytics/categories_tab.dart';
import 'package:urban_os/widgets/consumption_analytics/costs_tap.dart';
import 'package:urban_os/widgets/consumption_analytics/district_tabs.dart';
import 'package:urban_os/widgets/consumption_analytics/overview_tap.dart';
import 'package:urban_os/widgets/consumption_analytics/anomaly_tabs.dart';

typedef C = AppColors;

class ConsumptionAnalyticsScreen extends StatefulWidget {
  const ConsumptionAnalyticsScreen({super.key});
  @override
  State<ConsumptionAnalyticsScreen> createState() =>
      _ConsumptionAnalyticsState();
}

class _ConsumptionAnalyticsState extends State<ConsumptionAnalyticsScreen>
    with TickerProviderStateMixin {
  // ── data ──
  TimeRange _range = TimeRange.d7;
  ChartMode _chartMode = ChartMode.consumption;
  ViewTab _tab = ViewTab.overview;

  late List<ConsumptionPoint> _series;
  late List<DistrictConsumption> _districts;
  late List<CategoryData> _categories;
  late List<AnomalyEvent> _anomalies;
  late List<HourlyHeatmapCell> _heatmap;

  String? _selectedDistrictId;
  int _hoverIndex = -1;

  // cost config
  double _tariffPeak = 0.18; // $ / kWh
  double _tariffOffPeak = 0.09;
  bool _showCostMode = false;

  // compare

  // forecast

  // export
  bool _exporting = false;

  // ── animations ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _chartAnimCtrl;
  late AnimationController _barAnimCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _chartAnim;
  late Animation<double> _barAnim;

  final _scrollCtrl = ScrollController();

  // ── derived ──
  double get _totalKWh => _series.fold(0.0, (s, p) => s + p.value);
  double get _prevTotalKWh => _series.fold(0.0, (s, p) => s + p.prevValue);
  double get _totalCost => _series.fold(0.0, (s, p) => s + p.cost);
  double get _peakKWh => _series.map((p) => p.value).reduce(max);
  double get _avgKWh => _totalKWh / _series.length;
  double get _changeVsPrev =>
      _prevTotalKWh > 0 ? (_totalKWh - _prevTotalKWh) / _prevTotalKWh * 100 : 0;
  int get _anomalyCount => _anomalies.where((a) => !a.acknowledged).length;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _loadData() {
    _series = buildSeries(_range);
    _districts = buildDistricts();
    _categories = buildCategories(_totalKWh);
    _anomalies = buildAnomalies();
    _heatmap = buildHeatmap();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _chartAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _barAnimCtrl = AnimationController(
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
    _chartAnim = CurvedAnimation(
      parent: _chartAnimCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _barAnim = CurvedAnimation(
      parent: _barAnimCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _chartAnimCtrl.forward();
    _barAnimCtrl.forward();
  }

  void _switchRange(TimeRange r) {
    setState(() {
      _range = r;
      _series = buildSeries(r);
      _hoverIndex = -1;
    });
    _chartAnimCtrl.forward(from: 0);
    _barAnimCtrl.forward(from: 0);
  }

  void _switchChartMode(ChartMode m) {
    setState(() {
      _chartMode = m;
    });
    _chartAnimCtrl.forward(from: 0);
  }

  void _switchTab(ViewTab t) {
    setState(() => _tab = t);
    _barAnimCtrl.forward(from: 0);
  }

  void _toggleCostMode() {
    setState(() => _showCostMode = !_showCostMode);
  }

  void _resetDistrictSelection() {
    setState(() => _selectedDistrictId = null);
  }

  void _handleDistrictTap(DistrictConsumption d) {
    setState(() => _selectedDistrictId = d.id);
  }

  void _acknowledgeAll() {
    setState(() {
      for (final a in _anomalies) {
        a.acknowledged = true;
      }
    });
  }

  void _acknowledgeOne(AnomalyEvent a) {
    setState(() => a.acknowledged = true);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _chartAnimCtrl.dispose();
    _barAnimCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  ROOT BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: _bgCtrl.value, glow: _glowCtrl.value),
              size: Size.infinite,
            ),
          ),
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
                    ConsumptionAnalyticsHeader(
                      glowCtrl: _glowCtrl,
                      pulseCtrl: _pulseCtrl,
                      showCostMode: _showCostMode,
                      onToggleCostMode: _toggleCostMode,
                      range: _range,
                      anomalyCount: _anomalyCount,
                      exporting: _exporting,
                      onExport: _handleExport,
                    ),
                    KpiStrip(
                      glowCtrl: _glowCtrl,
                      blinkCtrl: _blinkCtrl,
                      showCostMode: _showCostMode,
                      totalKWh: _totalKWh,
                      totalCost: _totalCost,
                      changeVsPrev: _changeVsPrev,
                      peakKWh: _peakKWh,
                      avgKWh: _avgKWh,
                      anomalyCount: _anomalyCount,
                    ),
                    RangeBar(
                      currentRange: _range,
                      onRangeSelected: _switchRange,
                    ),
                    ChartModeBar(
                      currentMode: _chartMode,
                      onModeSelected: _switchChartMode,
                    ),
                    Expanded(
                      child: DashboardBody(
                        selectedTab: _tab,
                        anomalyCount: _anomalyCount,
                        onTabSelected: _switchTab,
                        overviewTab: OverviewTab(
                          scrollController: _scrollCtrl,
                          series: _series,
                          categories: _categories,
                          heatmap: _heatmap,
                          range: _range,
                          chartMode: _chartMode,
                          showCostMode: _showCostMode,
                          glowCtrl: _glowCtrl,
                          chartAnim: _chartAnim,
                          blinkCtrl: _blinkCtrl,
                        ),
                        districtsTab: DistrictsTab(
                          districts: _districts,
                          selectedDistrictId: _selectedDistrictId,
                          glowCtrl: _glowCtrl,
                          blinkCtrl: _blinkCtrl,
                          barAnim: _barAnim,
                          onResetSelection: _resetDistrictSelection,
                          onDistrictTap: _handleDistrictTap,
                        ),
                        categoriesTab: CategoriesTab(
                          categories: _categories,
                          glowCtrl: _glowCtrl,
                          barAnim: _barAnim,
                        ),
                        costsTab: CostsTab(
                          tariffPeak: _tariffPeak,
                          tariffOffPeak: _tariffOffPeak,
                          districts: _districts,
                          showCostMode: _showCostMode,
                          totalCost: _totalCost,
                          glowAnimation: _glowCtrl,
                          barAnimation: _barAnim,
                          onPeakChanged: (v) => setState(() => _tariffPeak = v),
                          onOffPeakChanged: (v) =>
                              setState(() => _tariffOffPeak = v),
                        ),
                        anomaliesTab: AnomaliesTab(
                          anomalies: _anomalies,
                          anomalyCount: _anomalyCount,
                          series: _series,
                          glowAnimation: _glowCtrl,
                          blinkAnimation: _blinkCtrl,
                          onAcknowledgeAll: _acknowledgeAll,
                          onAcknowledgeOne: _acknowledgeOne,
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

  void _handleExport() async {
    setState(() => _exporting = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _exporting = false);
  }
}
