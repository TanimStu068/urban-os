import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';
import 'package:urban_os/widgets/event_injection/event_builder.dart';
import 'package:urban_os/widgets/event_injection/event_injection_header.dart';
import 'package:urban_os/widgets/event_injection/event_list.dart';
import 'package:urban_os/widgets/event_injection/event_stat_bar.dart';
import 'package:urban_os/widgets/event_injection/event_tab_bar.dart';

// ─────────────────────────────────────────
//  COLOR PALETTE (UrbanOS — Event Injection)
// ─────────────────────────────────────────
typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class EventInjectionScreen extends StatefulWidget {
  const EventInjectionScreen({super.key});

  @override
  State<EventInjectionScreen> createState() => _EventInjectionScreenState();
}

class _EventInjectionScreenState extends State<EventInjectionScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late List<InjectedEvent> _activeEvents;
  late List<EventTemplate> _templates;

  EventType? _selectedEventType;
  EventSeverity _selectedSeverity = EventSeverity.high;
  ImpactArea _selectedImpact = ImpactArea.district;
  int _durationMinutes = 30;
  String _locationInput = '';

  String _viewTab = 'ACTIVE';
  bool _showBuilder = false;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeEvents = buildActiveEvents();
    _templates = buildTemplates();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _cancel() {
    setState(() {
      _showBuilder = false;
      _selectedEventType = null;
      _locationInput = '';
      _durationMinutes = 30;
    });
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
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

  void _injectEvent() {
    if (_selectedEventType == null || _locationInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event type and location')),
      );
      return;
    }

    final newEvent = InjectedEvent(
      id: 'EVT-${_activeEvents.length + 100}',
      type: _selectedEventType!,
      severity: _selectedSeverity,
      description:
          '${_selectedEventType!.label} event injected via scenario builder',
      location: _locationInput,
      impactArea: _selectedImpact,
      status: EventStatus.scheduled,
      createdAt: DateTime.now(),
      durationSeconds: _durationMinutes * 60,
      elapsedSeconds: 0,
      affectedSystems: _templates
          .firstWhere((t) => t.type == _selectedEventType)
          .affectedSystems,
      parameters: {
        'injectedBy': 'User',
        'severity': _selectedSeverity.label,
        'impact': _selectedImpact.label,
      },
    );

    setState(() {
      _activeEvents.insert(0, newEvent);
      _selectedEventType = null;
      _locationInput = '';
      _durationMinutes = 30;
      _showBuilder = false;
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
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
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.5, -0.2),
                  radius: 1.3,
                  colors: [C.cyan.withOpacity(0.04), C.bg],
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
                      C.cyan.withOpacity(0.05),
                      C.cyan.withOpacity(0.10),
                      C.cyan.withOpacity(0.05),
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
                    EventInjectionHeader(
                      glowAnimation: _glowCtrl,
                      onBackTap: () {
                        // Optional: custom back action
                        Navigator.pop(context);
                      },
                    ),
                    EventStatsBar(
                      activeCount: _activeEvents
                          .where((e) => e.status == EventStatus.active)
                          .length,
                      totalCount: _activeEvents.length,
                      templateCount: _templates.length,
                      systemsCount: _activeEvents.fold(
                        0,
                        (sum, e) => sum + e.systemsAffected,
                      ),
                    ),
                    if (!_showBuilder)
                      EventTabBar(
                        selectedTab: _viewTab,
                        onTabChanged: (tab) => setState(() => _viewTab = tab),
                        onNewPressed: () => setState(() => _showBuilder = true),
                      ),
                    Expanded(
                      child: _showBuilder
                          ? EventBuilder(
                              templates: _templates,
                              selectedEventType: _selectedEventType,
                              onEventTypeSelected: (type) =>
                                  setState(() => _selectedEventType = type),
                              locationInput: _locationInput,
                              onLocationChanged: (val) =>
                                  setState(() => _locationInput = val),
                              selectedSeverity: _selectedSeverity,
                              onSeverityChanged: (sev) =>
                                  setState(() => _selectedSeverity = sev),
                              selectedImpact: _selectedImpact,
                              onImpactChanged: (imp) =>
                                  setState(() => _selectedImpact = imp),
                              durationMinutes: _durationMinutes,
                              onDurationChanged: (min) =>
                                  setState(() => _durationMinutes = min),
                              onCancel: _cancel,
                              onInjectEvent: _injectEvent,
                            )
                          : EventList(
                              events: _activeEvents,
                              viewTab: _viewTab,
                              scrollController: _scrollCtrl,
                              pulseCtrl: _pulseCtrl,
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
