import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_type.dart';
import 'package:urban_os/providers/district/district_provider.dart';

import 'package:urban_os/screens/districts/district_analytics_screen.dart';
import 'package:urban_os/screens/districts/district_detail_screen.dart';
import 'package:urban_os/screens/districts/district_map_screen.dart';
import 'package:urban_os/widgets/city_dashboard/kpi_row.dart';
import 'package:urban_os/widgets/district_list/district_bg_painter.dart';
import 'package:urban_os/widgets/district_list/district_filter_bar.dart';
import 'package:urban_os/widgets/district_list/district_header.dart';
import 'package:urban_os/widgets/district_list/district_list_view.dart';
import 'package:urban_os/widgets/district_list/district_search_bar.dart';
import 'package:urban_os/widgets/district_list/loader_district_widget.dart';

typedef C = AppColors;

class DistrictListScreen extends StatefulWidget {
  const DistrictListScreen({super.key});

  @override
  State<DistrictListScreen> createState() => _DistrictListScreenState();
}

class _DistrictListScreenState extends State<DistrictListScreen>
    with TickerProviderStateMixin {
  // ── Filters ──
  DistrictType? _typeFilter;
  String _searchQuery = '';
  int _sortMode = 0; // 0=health 1=name 2=incidents 3=sensors
  bool _criticalOnly = false;

  // ── Animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
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
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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

    _searchCtrl.addListener(
      () => setState(() => _searchQuery = _searchCtrl.text),
    );
    _entranceCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DistrictProvider>().loadDistricts();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Filter + sort pipeline ──
  List<DistrictModel> _getFiltered(List<DistrictModel> districts) {
    var result = districts.toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (d) =>
                d.name.toLowerCase().contains(q) ||
                d.id.toLowerCase().contains(q) ||
                d.type.displayName.toLowerCase().contains(q) ||
                (d.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    if (_typeFilter != null) {
      result = result.where((d) => d.type == _typeFilter).toList();
    }
    if (_criticalOnly) {
      result = result.where((d) => d.metrics.hasCriticalIssues).toList();
    }

    switch (_sortMode) {
      case 0:
        result.sort((a, b) => b.healthPercentage.compareTo(a.healthPercentage));
        break;
      case 1:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 2:
        result.sort(
          (a, b) =>
              b.metrics.activeIncidents.compareTo(a.metrics.activeIncidents),
        );
        break;
      case 3:
        result.sort((a, b) => b.sensorCount.compareTo(a.sensorCount));
        break;
    }
    return result;
  }

  void _openDetails(DistrictModel d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DistrictDetailsScreen(district: d)),
    );
  }

  void _openAnalysis(DistrictModel d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DistrictAnalysisScreen(district: d)),
    );
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DistrictMapScreen()),
    );
  }

  Widget _buildKpiRow(DistrictProvider dp) {
    final districts = dp.districts;
    if (districts.isEmpty) {
      return const SizedBox(height: 72);
    }
    final avgEnergy =
        districts
            .map((d) => d.metrics.energyConsumption)
            .fold(0.0, (a, b) => a + b) /
        districts.length;
    final avgTraffic =
        districts
            .map((d) => d.metrics.averageTraffic)
            .fold(0.0, (a, b) => a + b) /
        districts.length;
    final avgAqi =
        districts
            .map((d) => d.metrics.airQualityIndex)
            .fold(0.0, (a, b) => a + b) /
        districts.length;
    final avgWater =
        districts
            .map((d) => d.metrics.waterConsumption ?? 0)
            .fold(0.0, (a, b) => a + b) /
        districts.length;

    return KpiRow(
      energy: avgEnergy.clamp(0, 100),
      traffic: avgTraffic.clamp(0, 100),
      aqi: avgAqi,
      water: avgWater.clamp(0, 100),
      glowCtrl: _glowCtrl,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, color: C.mutedLt, size: 40),
          const SizedBox(height: 12),
          const Text(
            'No districts match filters',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: C.mutedLt,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Animated grid bg
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: DistrictBgPainter(_bgCtrl.value),
              size: Size.infinite,
            ),
          ),
          // Scan line
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
                      C.cyan.withOpacity(0.08),
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
                child: Consumer<DistrictProvider>(
                  builder: (_, dp, __) {
                    final filtered = _getFiltered(dp.districts);
                    return Column(
                      children: [
                        DistrictHeader(
                          districtProvider: dp,
                          glowAnimation: _glowCtrl,
                          blinkAnimation: _blinkCtrl,
                          openMap: _openMap,
                        ),
                        DistrictSearchBar(),
                        _buildKpiRow(dp),
                        DistrictFilterBar(
                          districtProvider: dp,
                          initialFilter: _typeFilter,
                          onFilterChanged: (filter) {
                            setState(() {
                              _typeFilter = filter;
                            });
                          },
                        ),
                        Expanded(
                          child: dp.isLoading
                              ? LoaderDistrictWidget(pulseAnimation: _pulseCtrl)
                              : dp.districts.isEmpty
                              ? _buildEmpty()
                              : DistrictListView(
                                  items: filtered,
                                  scrollController: _scrollCtrl,
                                  glowAnimation: _glowCtrl,
                                  blinkAnimation: _blinkCtrl,
                                  pulseAnimation: _pulseCtrl,
                                  openDetails: _openDetails,
                                  openAnalysis: _openAnalysis,
                                  openMap: _openMap,
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
