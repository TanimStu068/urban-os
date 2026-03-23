import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/datamodel/alert_history_data_model.dart';
import 'package:urban_os/widgets/alert_history/alert_filter_bar.dart';
import 'package:urban_os/widgets/alert_history/alert_header.dart';
import 'package:urban_os/widgets/alert_history/alert_list.dart';
import 'package:urban_os/widgets/alert_history/alert_stat_bar.dart';

typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class AlertHistoryScreen extends StatefulWidget {
  const AlertHistoryScreen({super.key});

  @override
  State<AlertHistoryScreen> createState() => _AlertHistoryState();
}

class _AlertHistoryState extends State<AlertHistoryScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<AlertLog> _allAlerts;
  late List<AlertLog> _filteredAlerts;
  late AlertStatistics _stats;

  AlertSeverity? _selectedSeverity;
  AlertType? _selectedType;
  AlertStatus? _selectedStatus;
  String _searchQuery = '';
  Set<AlertLog> _expandedAlerts = {};

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Try to load from LogProvider, fallback to mock data
    try {
      final logProvider = context.read<LogProvider>();
      if (logProvider.alerts.isNotEmpty) {
        // Convert model AlertLog to local AlertLog format
        _allAlerts = logProvider.alerts.map((modelAlert) {
          return AlertLog(
            id: modelAlert.id,
            title: modelAlert.title,
            description: modelAlert.description,
            severity: _mapPriorityToSeverity(modelAlert.severity),
            type: AlertType.system, // Default to system type
            sourceId: modelAlert.resourceId ?? 'SYS-0000',
            sourceName: 'System',
            timestamp: modelAlert.timestamp,
            status: _mapResolvedToStatus(modelAlert.resolvedAt),
            actionTaken: modelAlert.resolutionNotes,
            resolvedAt: modelAlert.resolvedAt,
            affectedSystems: 1,
          );
        }).toList();
      } else {
        _allAlerts = buildAlertHistory();
      }
    } catch (e) {
      // LogProvider not available, use mock data
      _allAlerts = buildAlertHistory();
    }
    _filteredAlerts = List.from(_allAlerts);
    _stats = buildStatistics(_allAlerts);
    _initAnims();
    _entranceCtrl.forward();
  }

  /// Map RulePriority to local AlertSeverity
  AlertSeverity _mapPriorityToSeverity(dynamic priority) {
    final priorityStr = priority.toString();
    if (priorityStr.contains('critical')) {
      return AlertSeverity.critical;
    } else if (priorityStr.contains('high')) {
      return AlertSeverity.warning;
    } else if (priorityStr.contains('medium')) {
      return AlertSeverity.warning;
    } else {
      return AlertSeverity.info;
    }
  }

  /// Map resolved status to local AlertStatus
  AlertStatus _mapResolvedToStatus(DateTime? resolvedAt) {
    return resolvedAt != null ? AlertStatus.resolved : AlertStatus.active;
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

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));
  }

  void _applyFilters() {
    setState(() {
      _filteredAlerts = _allAlerts.where((alert) {
        if (_selectedSeverity != null && alert.severity != _selectedSeverity) {
          return false;
        }
        if (_selectedType != null && alert.type != _selectedType) {
          return false;
        }
        if (_selectedStatus != null && alert.status != _selectedStatus) {
          return false;
        }
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return alert.title.toLowerCase().contains(query) ||
              alert.description.toLowerCase().contains(query) ||
              alert.sourceName.toLowerCase().contains(query);
        }
        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedSeverity = null;
      _selectedType = null;
      _selectedStatus = null;
      _searchQuery = '';
      _filteredAlerts = List.from(_allAlerts);
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -0.3),
                  radius: 1.2,
                  colors: [C.red.withOpacity(0.04), C.bg],
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
                      C.red.withOpacity(0.04),
                      C.red.withOpacity(0.10),
                      C.red.withOpacity(0.04),
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
                    AlertsHeader(
                      glowAnimation: _glowCtrl,
                      totalAlerts: _filteredAlerts.length,
                      activeAlerts: _stats.activeAlerts,
                    ),

                    AlertsStatsBar(stats: _stats),
                    AlertsFilterBar(
                      searchQuery: _searchQuery,
                      selectedSeverity: _selectedSeverity,
                      selectedType: _selectedType,
                      selectedStatus: _selectedStatus,
                      onSearchChanged: (val) {
                        setState(() => _searchQuery = val);
                        _applyFilters();
                      },
                      onSeveritySelected: (sev) {
                        setState(() => _selectedSeverity = sev);
                        _applyFilters();
                      },
                      onTypeSelected: (type) {
                        setState(() => _selectedType = type);
                        _applyFilters();
                      },
                      onStatusSelected: (status) {
                        setState(() => _selectedStatus = status);
                        _applyFilters();
                      },
                      onClearFilters: _clearFilters,
                    ),

                    Expanded(
                      child: AlertsListWidget(
                        filteredAlerts: _filteredAlerts,
                        scrollController: _scrollCtrl,
                        expandedAlerts: _expandedAlerts,
                        onToggleExpanded: (id) {
                          final alert = _filteredAlerts.firstWhere(
                            (a) => a.id == id,
                          );
                          if (_expandedAlerts.contains(alert)) {
                            _expandedAlerts.remove(alert);
                          } else {
                            _expandedAlerts.add(alert);
                          }
                          setState(() {});
                        },
                        onStatusChange: (alert, status) {
                          alert.status = status;
                          setState(() {
                            _stats = buildStatistics(_allAlerts);
                          });
                        },
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

  @override
  void deactivate() {
    super.deactivate();
  }
}
