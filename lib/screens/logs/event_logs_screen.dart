import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_log_data_model.dart';
import 'package:urban_os/widgets/event_logs/events_filter_bar.dart';
import 'package:urban_os/widgets/event_logs/events_header.dart';
import 'package:urban_os/widgets/event_logs/events_list.dart';
import 'package:urban_os/widgets/event_logs/stat_item.dart';

typedef C = AppColors;

const kAccent = C.teal;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class EventLogsScreen extends StatefulWidget {
  const EventLogsScreen({super.key});

  @override
  State<EventLogsScreen> createState() => _EventLogsState();
}

class _EventLogsState extends State<EventLogsScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<EventLog> _allEvents;
  late List<EventLog> _filteredEvents;
  late EventStatistics _stats;

  EventType? _selectedType;
  EventSeverity? _selectedSeverity;
  String _searchQuery = '';
  bool _showSuccessOnly = false;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;

  final Set<EventLog> _expandedEvents = {};
  final ScrollController _scrollController = ScrollController();

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _allEvents = buildEventLogs();
    _filteredEvents = List.from(_allEvents);
    _stats = buildStatistics(_allEvents);
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

  void applyFilters() {
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        if (_selectedType != null && event.type != _selectedType) return false;
        if (_selectedSeverity != null && event.severity != _selectedSeverity)
          return false;
        if (_showSuccessOnly && !event.success) return false;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return event.title.toLowerCase().contains(query) ||
              event.description.toLowerCase().contains(query) ||
              event.sourceModule.toLowerCase().contains(query);
        }
        return true;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedSeverity = null;
      _showSuccessOnly = false;
      _searchQuery = '';
      _filteredEvents = List.from(_allEvents);
    });
  }

  void toggleEventExpanded(String eventId) {
    setState(() {
      final event = _filteredEvents.firstWhere((e) => e.id == eventId);
      if (_expandedEvents.contains(event)) {
        _expandedEvents.remove(event);
      } else {
        _expandedEvents.add(event);
      }
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
                  colors: [C.sky.withOpacity(0.04), C.bg],
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
                      C.sky.withOpacity(0.04),
                      C.sky.withOpacity(0.10),
                      C.sky.withOpacity(0.04),
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
                    EventsHeader(
                      glowAnimation: _glowCtrl,
                      filteredCount: _filteredEvents.length,
                      totalEvents: _stats.totalEvents,
                      onBack: () => Navigator.maybePop(context),
                    ),
                    EventsStatsBar(stats: _stats),
                    EventsFilterBar(
                      searchQuery: _searchQuery,
                      selectedType: _selectedType,
                      selectedSeverity: _selectedSeverity,
                      showSuccessOnly: _showSuccessOnly,
                      onSearchChanged: (val) {
                        setState(() => _searchQuery = val);
                        applyFilters();
                      },
                      onTypeSelected: (type) {
                        setState(() => _selectedType = type);
                        applyFilters();
                      },
                      onSeveritySelected: (sev) {
                        setState(() => _selectedSeverity = sev);
                        applyFilters();
                      },
                      onToggleSuccessOnly: () {
                        setState(() => _showSuccessOnly = !_showSuccessOnly);
                        applyFilters();
                      },
                      onClearFilters: clearFilters,
                    ),
                    Expanded(
                      child: EventsListWidget(
                        filteredEvents: _filteredEvents,
                        expandedEvents: _expandedEvents,
                        scrollController: _scrollController,
                        onToggleExpanded: toggleEventExpanded,
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
