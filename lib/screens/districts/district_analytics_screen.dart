import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_analytics/analysis_bg_painter.dart';
import 'package:urban_os/widgets/district_analytics/analysis_header.dart';
import 'package:urban_os/widgets/district_analytics/chart_panel.dart';
import 'package:urban_os/widgets/district_analytics/insight_panel.dart';
import 'package:urban_os/widgets/district_analytics/metric_bar.dart';
import 'package:urban_os/widgets/district_analytics/ranking_panel.dart';
import 'package:urban_os/widgets/district_analytics/score_card.dart';
import 'package:urban_os/widgets/district_analytics/view_toggle.dart';

typedef C = AppColors;

class DistrictAnalysisScreen extends StatefulWidget {
  final DistrictModel district;
  const DistrictAnalysisScreen({super.key, required this.district});

  @override
  State<DistrictAnalysisScreen> createState() => _DistrictAnalysisScreenState();
}

class _DistrictAnalysisScreenState extends State<DistrictAnalysisScreen>
    with TickerProviderStateMixin {
  int _viewMode = 0;

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _drawCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _drawAnim;

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
      duration: const Duration(seconds: 8),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _drawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.04), end: Offset.zero));
    _drawAnim = CurvedAnimation(parent: _drawCtrl, curve: Curves.easeOut);

    _entranceCtrl.forward();
    _drawCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _drawCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _setView(int v) {
    setState(() => _viewMode = v);
    _drawCtrl.forward(from: 0);
  }

  DistrictModel get _d => widget.district;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgCtrl, _scanCtrl]),
        builder: (_, __) => Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: AnalysisBgPainter(_bgCtrl.value)),
            ),
            Positioned(
              top: _scanCtrl.value * size.height,
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.violet.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: Consumer<DistrictProvider>(
                    builder: (_, dp, __) {
                      final live = dp.getDistrict(_d.id) ?? _d;
                      return Column(
                        children: [
                          AnalysisHeader(
                            d: live,
                            glowAnim: _glowCtrl,
                            onBack: () => Navigator.pop(context),
                          ),
                          ViewToggle(viewMode: _viewMode, onChanged: _setView),
                          Expanded(
                            child: CustomScrollView(
                              controller: _scrollCtrl,
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    14,
                                    16,
                                    100,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildListDelegate([
                                      ScoreCard(
                                        d: live,
                                        glowAnim: _glowCtrl,
                                        pulseAnim: _pulseCtrl,
                                      ),
                                      const SizedBox(height: 16),
                                      ChartPanel(
                                        d: live,
                                        dp: dp,
                                        drawAnim: _drawAnim,
                                        pulseAnim: _pulseCtrl,
                                        viewMode: _viewMode,
                                      ),
                                      const SizedBox(height: 16),
                                      MetricBars(d: live, drawAnim: _drawAnim),
                                      const SizedBox(height: 16),
                                      RankingsPanel(d: live, dp: dp),
                                      const SizedBox(height: 16),
                                      InsightsPanel(d: live),
                                    ]),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
