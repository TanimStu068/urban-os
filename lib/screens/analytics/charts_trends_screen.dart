import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/datamodel/charts_trends_datamodel.dart';
import 'package:urban_os/widgets/chartsTrends/build_header.dart';
import 'package:urban_os/widgets/chartsTrends/gridbg_painter.dart';
import 'package:urban_os/widgets/chartsTrends/hover_detail.dart';
import 'package:urban_os/widgets/chartsTrends/kpi_row_widget.dart';
import 'package:urban_os/widgets/chartsTrends/level_dist.dart';
import 'package:urban_os/widgets/chartsTrends/main_chart.dart';
import 'package:urban_os/widgets/chartsTrends/metrict_toggles.dart';
import 'package:urban_os/widgets/chartsTrends/period_bar.dart';
import 'package:urban_os/widgets/chartsTrends/recent_activity.dart';
import 'package:urban_os/widgets/chartsTrends/severity_dist.dart';
import 'package:urban_os/widgets/chartsTrends/stacked_bar.dart';

typedef C = AppColors;

class ChartsTrendsScreen extends StatefulWidget {
  const ChartsTrendsScreen({super.key});

  @override
  State<ChartsTrendsScreen> createState() => _ChartsTrendsScreenState();
}

class _ChartsTrendsScreenState extends State<ChartsTrendsScreen>
    with TickerProviderStateMixin {
  TrendPeriod _period = TrendPeriod.h24;
  final Set<MetricType> _activeMetrics = {MetricType.alerts, MetricType.events};
  bool _showDistribution = false;

  // Hover state for chart
  int? _hoverBucket;

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _drawCtrl; // line draw
  late AnimationController _entranceCtrl;

  late Animation<double> _drawAnim;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _rng = Random(42);

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
      duration: const Duration(seconds: 8),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _drawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _drawAnim = CurvedAnimation(parent: _drawCtrl, curve: Curves.easeInOut);
    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.05), end: Offset.zero));

    _entranceCtrl.forward();
    _drawCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _drawCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _setPeriod(TrendPeriod p) {
    setState(() {
      _period = p;
      _hoverBucket = null;
    });
    _drawCtrl.forward(from: 0);
  }

  void _toggleMetric(MetricType m) {
    setState(() {
      if (_activeMetrics.contains(m)) {
        if (_activeMetrics.length > 1) _activeMetrics.remove(m);
      } else {
        _activeMetrics.add(m);
      }
      _hoverBucket = null;
    });
    _drawCtrl.forward(from: 0);
  }

  // ── Synthetic data from provider + fill gaps ──
  List<SeriesData> _buildSeries(LogProvider lp) {
    final buckets = _period.buckets;
    final now = DateTime.now();
    final slotMs = _period.index < 2
        ? Duration(hours: 1).inMilliseconds
        : Duration(hours: 24).inMilliseconds;

    // Alerts
    final alertBuckets = List<double>.filled(buckets, 0.0, growable: true);
    for (final a in lp.alerts) {
      final diff = now.difference(a.timestamp).inMilliseconds;
      final idx = buckets - 1 - (diff ~/ slotMs);
      if (idx >= 0 && idx < buckets) alertBuckets[idx]++;
    }
    // Pad with synthetic noise if empty (demo mode)
    if (alertBuckets.every((v) => v == 0)) {
      for (int i = 0; i < buckets; i++) {
        alertBuckets[i] = (_rng.nextDouble() * 12 + 1).roundToDouble();
      }
    }

    // Events
    final eventBuckets = List<double>.filled(buckets, 0.0, growable: true);
    for (final e in lp.events) {
      final diff = now.difference(e.timestamp).inMilliseconds;
      final idx = buckets - 1 - (diff ~/ slotMs);
      if (idx >= 0 && idx < buckets) eventBuckets[idx]++;
    }
    if (eventBuckets.every((v) => v == 0)) {
      for (int i = 0; i < buckets; i++) {
        eventBuckets[i] = (_rng.nextDouble() * 40 + 5).roundToDouble();
      }
    }

    // Triggers & Throughput are synthetic / placeholder
    final trigBuckets = List.generate(
      buckets,
      (i) => (_rng.nextDouble() * 8).roundToDouble(),
    );
    final throughBuckets = List.generate(
      buckets,
      (i) => (20 + _rng.nextDouble() * 80).roundToDouble(),
    );

    return [
      SeriesData(
        MetricType.alerts,
        List.generate(buckets, (i) => DataPoint(i, alertBuckets[i])),
      ),
      SeriesData(
        MetricType.events,
        List.generate(buckets, (i) => DataPoint(i, eventBuckets[i])),
      ),
      SeriesData(
        MetricType.triggers,
        List.generate(buckets, (i) => DataPoint(i, trigBuckets[i])),
      ),
      SeriesData(
        MetricType.throughput,
        List.generate(buckets, (i) => DataPoint(i, throughBuckets[i])),
      ),
    ];
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (ctx, lp, _) {
        final series = _buildSeries(lp);
        final activeSeries = series
            .where((s) => _activeMetrics.contains(s.metric))
            .toList();

        return Scaffold(
          backgroundColor: C.bg,
          body: AnimatedBuilder(
            animation: Listenable.merge([
              _bgCtrl,
              _glowCtrl,
              _scanCtrl,
              _blinkCtrl,
              _entranceCtrl,
            ]),
            builder: (_, __) => Stack(
              children: [
                // Animated grid bg
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridBgPainter(_bgCtrl.value, _scanCtrl.value),
                  ),
                ),

                // Main content
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnalyticsHeader(
                            lp: lp,
                            glowCtrl: _glowCtrl,
                            blinkCtrl: _blinkCtrl,
                            showDistribution: _showDistribution,
                            onToggleDistribution: () {
                              setState(() {
                                _showDistribution = !_showDistribution;
                              });
                            },
                          ),
                          PeriodBar(
                            period: _period,
                            onPeriodChanged: _setPeriod,
                          ),
                          MetricToggles(
                            series: series,
                            activeMetrics: _activeMetrics,
                            onToggleMetric: _toggleMetric,
                          ),
                          Expanded(
                            child: CustomScrollView(
                              controller: _scrollCtrl,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: KpiRowWidget(
                                    activeSeries: activeSeries,
                                    glowAnimation: _glowCtrl,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: MainChartWidget(
                                    activeSeries: activeSeries,
                                    drawAnimation: _drawAnim,
                                    period: _period,
                                    hoverBucket: _hoverBucket,
                                    onHoverBucketChanged: (b) =>
                                        setState(() => _hoverBucket = b),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: HoverDetailWidget(
                                    activeSeries: activeSeries,
                                    hoverBucket: _hoverBucket,
                                    period: _period,
                                  ),
                                ),
                                if (_showDistribution) ...[
                                  SliverToBoxAdapter(
                                    child: SeverityDistributionWidget(
                                      logProvider: lp,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: EventLevelBreakdownWidget(
                                      logProvider: lp,
                                    ),
                                  ),
                                ],
                                SliverToBoxAdapter(
                                  child: StackedActivityWidget(
                                    activeSeries: activeSeries,
                                    drawAnimation: _drawAnim,
                                    hoverBucket: _hoverBucket,
                                    periodLabel: _period.label,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: RecentActivityWidget(logProvider: lp),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 32),
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
          ),
        );
      },
    );
  }
}
