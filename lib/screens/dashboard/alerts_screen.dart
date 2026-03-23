import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/datamodel/city_alert_data_model.dart';
import 'package:urban_os/widgets/city_alerts/alert_card.dart';
import 'package:urban_os/widgets/city_alerts/alert_stat_summary.dart';
import 'package:urban_os/widgets/city_alerts/bg_painter.dart';
import 'package:urban_os/widgets/city_alerts/critical_wave.dart';
import 'package:urban_os/widgets/city_alerts/empty_state.dart';
import 'package:urban_os/widgets/city_alerts/filter_bar.dart';
import 'package:urban_os/widgets/city_alerts/inject_button.dart';
import 'package:urban_os/widgets/city_alerts/top_bar.dart';
import 'package:urban_os/widgets/city_alerts/grid_overlay.dart';
import 'package:urban_os/widgets/city_alerts/scan_beam.dart';
import 'package:urban_os/widgets/city_alerts/scan_line_painter.dart';

typedef C = AppColors;

class RealTimeAlertsScreen extends StatefulWidget {
  const RealTimeAlertsScreen({super.key});
  @override
  State<RealTimeAlertsScreen> createState() => _RealTimeAlertsState();
}

class _RealTimeAlertsState extends State<RealTimeAlertsScreen>
    with TickerProviderStateMixin {
  // Data
  late List<UIAlert> _uiAlerts;
  List<UIAlert> _filtered = [];
  RulePriority? _filterSeverity;
  String _searchQuery = '';
  bool _showAcknowledged = true;
  int _sortMode = 0; // 0=time, 1=severity
  final _searchCtrl = TextEditingController();

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _liveTickCtrl;
  late AnimationController _waveCtrl;

  // Entrance anims
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _statsFade;
  late Animation<double> _listFade;

  // Live ticker
  int _newAlertCount = 0;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _uiAlerts = [];
    _setupControllers();
    _setupAnimations();
    _entranceCtrl.forward();
    _liveTickCtrl.addListener(_onLiveTick);
  }

  void _setupControllers() {
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
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _liveTickCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  void _setupAnimations() {
    _headerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _headerSlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, -0.4), end: Offset.zero));
    _statsFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _listFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
  }

  void _onLiveTick() {
    if (_liveTickCtrl.value < 0.015 && mounted) {
      // Occasionally inject a new live alert
      if (_rng.nextDouble() > 0.55) {
        _injectLiveAlert();
      }
    }
  }

  void _injectLiveAlert() {
    final logProvider = context.read<LogProvider>();

    final s = samples[_rng.nextInt(samples.length)];
    logProvider.addAlert(
      AlertLog(
        id: 'ALT-${100 + _newAlertCount}',
        title: s.$1,
        description: s.$2,
        severity: s.$3,
        timestamp: DateTime.now(),
        createdAt: DateTime.now(),
        resourceType: 'sensor',
        isActive: true,
      ),
    );
    _newAlertCount++;
  }

  void _applyFilter() {
    final logProvider = context.read<LogProvider>();
    var list = logProvider.alerts
        .map((a) => UIAlert(alert: a, isExpanded: false))
        .toList();

    if (_filterSeverity != null) {
      list = list.where((a) => a.alert.severity == _filterSeverity).toList();
    }
    if (!_showAcknowledged) {
      list = list.where((a) => a.alert.isActive).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (a) =>
                a.alert.title.toLowerCase().contains(q) ||
                (a.alert.resourceType?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    if (_sortMode == 1) {
      list.sort(
        (a, b) => a.alert.severity.index.compareTo(b.alert.severity.index),
      );
    } else {
      list.sort((a, b) => b.alert.timestamp.compareTo(a.alert.timestamp));
    }
    setState(() => _filtered = list);
  }

  void _acknowledgeAlert(UIAlert uiAlert) {
    final logProvider = context.read<LogProvider>();
    logProvider.resolveAlert(
      uiAlert.alert.id,
      notes: 'Acknowledged by operator',
    );
    _applyFilter();
  }

  void _dismissAlert(UIAlert uiAlert) {
    setState(() {
      _uiAlerts.removeWhere((a) => a.alert.id == uiAlert.alert.id);
    });
    _applyFilter();
  }

  void _toggleExpand(UIAlert alert) {
    setState(() => alert.isExpanded = !alert.isExpanded);
  }

  int get _criticalCount {
    final logProvider = context.read<LogProvider>();
    return logProvider.alerts
        .where((a) => a.severity == RulePriority.critical && a.isActive)
        .length;
  }

  int get _warningCount {
    final logProvider = context.read<LogProvider>();
    return logProvider.alerts
        .where((a) => a.severity == RulePriority.high && a.isActive)
        .length;
  }

  int get _infoCount {
    final logProvider = context.read<LogProvider>();
    return logProvider.alerts
        .where(
          (a) =>
              (a.severity == RulePriority.medium ||
                  a.severity == RulePriority.low) &&
              a.isActive,
        )
        .length;
  }

  int get _resolvedCount {
    final logProvider = context.read<LogProvider>();
    return logProvider.alerts.where((a) => !a.isActive).length;
  }

  int get _totalActive {
    final logProvider = context.read<LogProvider>();
    return logProvider.alerts.where((a) => a.isActive).length;
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _entranceCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _liveTickCtrl.dispose();
    _waveCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Consumer<LogProvider>(
        builder: (context, logProvider, _) {
          // Defer filter application until after build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _uiAlerts = logProvider.alerts
                  .map((a) => UIAlert(alert: a, isExpanded: false))
                  .toList();
              _applyFilter();
            }
          });

          return Stack(
            children: [
              // Background layers
              CustomPaint(
                painter: BgPainter(anim: _bgCtrl),
                size: Size.infinite,
              ),
              Positioned.fill(child: GridOverlay(anim: _glowCtrl)),
              Positioned.fill(child: CustomPaint(painter: ScanlinePainter())),
              ScanBeam(anim: _scanCtrl, h: size.height),

              // Alert wave background (critical glow)
              if (_criticalCount > 0)
                CriticalWave(anim: _waveCtrl, count: _criticalCount),

              SafeArea(
                child: Column(
                  children: [
                    // ── TOP BAR ──
                    FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: TopBarWidget(
                          totalActive: _totalActive,
                          criticalCount: _criticalCount,
                          blinkCtrl: _blinkCtrl,
                        ),
                      ),
                    ),

                    // ── ALERT STAT SUMMARY ──
                    FadeTransition(
                      opacity: _statsFade,
                      child: AlertStatSummary(
                        critical: _criticalCount,
                        warning: _warningCount,
                        info: _infoCount,
                        resolved: _resolvedCount,
                        blinkCtrl: _blinkCtrl,
                        pulseCtrl: _pulseCtrl,
                      ),
                    ),

                    // ── FILTER + SEARCH BAR ──
                    FadeTransition(
                      opacity: _statsFade,
                      child: FilterBar(
                        filterSeverity: _filterSeverity,
                        showAcknowledged: _showAcknowledged,
                        sortMode: _sortMode,
                        searchCtrl: _searchCtrl,
                        onFilterChanged: (s) {
                          setState(
                            () => _filterSeverity = _filterSeverity == s
                                ? null
                                : s,
                          );
                          _applyFilter();
                        },
                        onToggleAck: () {
                          setState(
                            () => _showAcknowledged = !_showAcknowledged,
                          );
                          _applyFilter();
                        },
                        onSortChanged: (m) {
                          setState(() => _sortMode = m);
                          _applyFilter();
                        },
                        onSearchChanged: (q) {
                          setState(() => _searchQuery = q);
                          _applyFilter();
                        },
                      ),
                    ),

                    // ── ALERT LIST ──
                    Expanded(
                      child: FadeTransition(
                        opacity: _listFade,
                        child: _filtered.isEmpty
                            ? EmptyState(
                                filter: _filterSeverity,
                                query: _searchQuery,
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  100,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: _filtered.length,
                                itemBuilder: (ctx, i) => AlertCard(
                                  key: ValueKey(_filtered[i].alert.id),
                                  uiAlert: _filtered[i],
                                  index: i,
                                  blinkCtrl: _blinkCtrl,
                                  glowCtrl: _glowCtrl,
                                  onAcknowledge: () =>
                                      _acknowledgeAlert(_filtered[i]),
                                  onDismiss: () => _dismissAlert(_filtered[i]),
                                  onExpand: () => _toggleExpand(_filtered[i]),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── FLOATING INJECT BUTTON (demo) ──
              Positioned(
                bottom: 24,
                right: 20,
                child: FadeTransition(
                  opacity: _listFade,
                  child: InjectButton(
                    onTap: _injectLiveAlert,
                    pulseCtrl: _pulseCtrl,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
