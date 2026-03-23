import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/emergency_control_data_model.dart';
import 'package:urban_os/widgets/emergency_control/alert_list.dart';
import 'package:urban_os/widgets/emergency_control/control_bar.dart';
import 'package:urban_os/widgets/emergency_control/critical_alert_card.dart';
import 'package:urban_os/widgets/emergency_control/emergency_header.dart';
import 'package:urban_os/widgets/emergency_control/stat_bar.dart';

typedef C = AppColors;

const kAccent = C.red;

class EmergencyControlSystemScreen extends StatefulWidget {
  const EmergencyControlSystemScreen({super.key});

  @override
  State<EmergencyControlSystemScreen> createState() =>
      _EmergencyControlSystemState();
}

class _EmergencyControlSystemState extends State<EmergencyControlSystemScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<EmergencyAlert> _alerts;
  late List<ResponseTeam> _teams;

  String _filterSeverity = 'ALL';
  String _filterType = 'ALL';
  bool _showCompleted = false;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _alertCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _expandedAlerts = <String>{};

  @override
  void initState() {
    super.initState();
    _alerts = buildAlerts();
    _teams = buildTeams();
    _initAnims();
    _entranceCtrl.forward();
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
      duration: const Duration(seconds: 8),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _alertCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
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

  List<EmergencyAlert> get _filteredAlerts => _alerts.where((alert) {
    if (!_showCompleted && alert.status == DispatchStatus.completed)
      return false;
    if (_filterSeverity != 'ALL' && alert.severity.label != _filterSeverity)
      return false;
    if (_filterType != 'ALL' && alert.type.label != _filterType) return false;
    return true;
  }).toList();

  int get _activeIncidents => _alerts
      .where(
        (a) =>
            a.status != DispatchStatus.completed &&
            a.status != DispatchStatus.cancelled,
      )
      .length;
  int get _teamsDeployed =>
      _teams.where((t) => t.status != ResponseTeamStatus.idle).length;
  int get _totalAffected => _alerts.fold(0, (sum, a) => sum + a.affectedPeople);

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _alertCtrl.dispose();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.4, -0.4),
                  radius: 1.3,
                  colors: [C.red.withOpacity(0.05), C.bg],
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
                      C.red.withOpacity(0.06),
                      C.red.withOpacity(0.12),
                      C.red.withOpacity(0.06),
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
                    EmergencyHeader(
                      contextRef: context,
                      glowCtrl: _glowCtrl,
                      alertCtrl: _alertCtrl,
                      activeIncidents: _activeIncidents,
                      teamsDeployed: _teamsDeployed,
                    ),
                    CriticalAlertCard(alerts: _alerts, glowCtrl: _glowCtrl),
                    StatsBar(
                      activeIncidents: _activeIncidents,
                      teamsDeployed: _teamsDeployed,
                      totalAffected: _totalAffected,
                      alerts: _alerts,
                    ),
                    ControlBar(
                      filterSeverity: _filterSeverity,
                      filterType: _filterType,
                      showCompleted: _showCompleted,
                      onSeverityChanged: (val) =>
                          setState(() => _filterSeverity = val),
                      onTypeChanged: (val) => setState(() => _filterType = val),
                      onShowCompletedChanged: (val) =>
                          setState(() => _showCompleted = val),
                    ),
                    Expanded(
                      child: AlertList(
                        scrollCtrl: _scrollCtrl,
                        filteredAlerts: _filteredAlerts,
                        expandedAlerts: _expandedAlerts,
                        onToggleExpanded: (id) {
                          setState(() {
                            if (_expandedAlerts.contains(id)) {
                              _expandedAlerts.remove(id);
                            } else {
                              _expandedAlerts.add(id);
                            }
                          });
                        },
                        glowCtrl: _glowCtrl,
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
