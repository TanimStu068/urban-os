import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/district_detail_data_model.dart';
import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/providers/district/district_provider.dart';
import 'package:urban_os/widgets/district_detail/detail_bg_painter.dart';
import 'package:urban_os/widgets/district_detail/district_header.dart';
import 'package:urban_os/widgets/district_detail/district_taps.dart';
import 'package:urban_os/widgets/district_detail/hero_card.dart';
import 'package:urban_os/widgets/district_detail/tap_content.dart';

typedef C = AppColors;

class DistrictDetailsScreen extends StatefulWidget {
  final DistrictModel district;
  const DistrictDetailsScreen({super.key, required this.district});

  @override
  State<DistrictDetailsScreen> createState() => _DistrictDetailsScreenState();
}

class _DistrictDetailsScreenState extends State<DistrictDetailsScreen>
    with TickerProviderStateMixin {
  int _tab = 0; // 0=overview 1=sensors 2=actuators 3=history

  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

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
    blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  DistrictModel get d => widget.district;

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

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
              child: CustomPaint(painter: DetailBgPainter(_bgCtrl.value)),
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
                      C.cyan.withOpacity(0.06),
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
                      // Live update from provider if available
                      final live = dp.getDistrict(d.id) ?? d;
                      return Column(
                        children: [
                          DistrictHeader(
                            district: live,
                            glowAnim: _glowCtrl,
                            blinkAnim: blinkCtrl,
                            typeColor: (value) => typeColor(value),
                            onBack: () => Navigator.pop(context),
                          ),
                          HeroCard(
                            district: live,
                            glowAnim: _glowCtrl,
                            pulseAnim: _pulseCtrl,
                            healthColor: healthColor,
                            typeColor: (value) => typeColor(value),
                            aqiColor: (int value) => aqiColor(value.toDouble()),
                          ),
                          DistrictTabs(
                            currentTab: _tab,
                            onTabChanged: (i) => setState(() => _tab = i),
                          ),
                          Expanded(
                            child: TabContent(
                              d: live,
                              tab: _tab,
                              scrollCtrl: _scrollCtrl,
                              buildOverview: (d) => buildOverview(d, blinkCtrl),
                              buildSensorsTab: buildSensorsTab,
                              buildActuatorsTab: buildActuatorsTab,
                              buildHistoryTab: buildHistoryTab,
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
