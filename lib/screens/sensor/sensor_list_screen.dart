import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/loader/mock_data_loader.dart';

import 'package:urban_os/models/sensor/sensor_model.dart';
import 'package:urban_os/models/sensor/sensor_reading.dart';
import 'package:urban_os/models/sensor/sensor_state.dart';
import 'package:urban_os/models/sensor/sensor_type.dart';
import 'package:urban_os/providers/sensor/sensor_provider.dart';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';
import 'package:urban_os/widgets/sensor_list/empty_state.dart';
import 'package:urban_os/widgets/sensor_list/grid_line.dart';
import 'package:urban_os/widgets/sensor_list/header.dart';
import 'package:urban_os/widgets/sensor_list/search_bar.dart';
import 'package:urban_os/widgets/sensor_list/stats_bar.dart';
import 'package:urban_os/widgets/sensor_list/animated_background.dart';
import 'package:urban_os/widgets/sensor_list/categoy_chips.dart';
import 'package:urban_os/widgets/sensor_list/filter_panel.dart';
import 'package:urban_os/widgets/sensor_list/loading_shimmer.dart';
import 'package:urban_os/widgets/sensor_list/peek_panel.dart';
import 'package:urban_os/widgets/sensor_list/sensor_body.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
typedef _T = AppColors;

// ═════════════════════════════════════════════════════════════════════════════
//  SENSOR LIST SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class SensorListScreen extends StatefulWidget {
  const SensorListScreen({super.key});

  @override
  State<SensorListScreen> createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen>
    with TickerProviderStateMixin {
  // ── controllers ─────────────────────────────────────────────────────────
  late final AnimationController _bgPulse;
  late final AnimationController _entryAnim;
  late final AnimationController _shimmerAnim;
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // ── state ────────────────────────────────────────────────────────────────
  List<SensorModel> _allSensors = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _activeCategory; // null = All
  SensorState? _activeStateFilter; // null = All
  SortMode _sortMode = SortMode.name;
  bool _sortAsc = true;
  ViewMode _viewMode = ViewMode.list;
  SensorModel? _pinnedSensor; // detail-peek panel
  bool _showFiltersPanel = false;
  bool _showOfflineOnly = false;
  bool _showAlertOnly = false;

  // ── ticker for live-value animation ─────────────────────────────────────
  Timer? _liveTimer;

  // ═══════════════════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();

    _bgPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _shimmerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _loadSensors();
  }

  Future<void> _loadSensors() async {
    setState(() => _isLoading = true);
    try {
      // Try real provider first; fall back to MockDataLoader
      final provider = context.read<SensorProvider>();
      await Future.delayed(const Duration(milliseconds: 300));
      final providerSensors = provider.sensors;

      if (providerSensors.isNotEmpty) {
        _allSensors = providerSensors;
      } else {
        // Fallback: load directly from JSON via MockDataLoader
        _allSensors = await const MockDataLoader().loadSensors();
      }
      // Listen for future updates
      provider.addListener(_onSensorProviderUpdate);
    } catch (_) {
      _allSensors = await const MockDataLoader().loadSensors();
    }

    if (mounted) {
      setState(() => _isLoading = false);
      _entryAnim.forward();
      _startLiveTick();
    }
  }

  void _onSensorProviderUpdate() {
    if (!mounted || _isLoading) return;
    try {
      final provider = context.read<SensorProvider>();
      if (provider.sensors.isNotEmpty) {
        setState(() {
          _allSensors = provider.sensors;
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  void _startLiveTick() {
    // Every 2 s, nudge readings to simulate live updates
    _liveTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final rng = math.Random();
      setState(() {
        _allSensors = _allSensors.map((s) {
          if (s.state != SensorState.online) return s;
          final prev = s.latestReading?.value ?? 50.0;
          final nudge = (rng.nextDouble() - 0.5) * prev * 0.04;
          return s.copyWith(
            latestReading: SensorReading(
              value: (prev + nudge).clamp(0, 99999),
              timestamp: DateTime.now(),
              unit: s.latestReading?.unit,
              isAlert: s.latestReading?.isAlert ?? false,
            ),
          );
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    try {
      final provider = context.read<SensorProvider>();
      provider.removeListener(_onSensorProviderUpdate);
    } catch (e) {
      // Ignore
    }
    _bgPulse.dispose();
    _entryAnim.dispose();
    _shimmerAnim.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _liveTimer?.cancel();
    super.dispose();
  }

  // ── derived list ─────────────────────────────────────────────────────────
  List<SensorModel> get _filtered {
    var list = _allSensors.where((s) {
      // Search
      final q = _searchQuery.toLowerCase();
      if (q.isNotEmpty) {
        final hit =
            s.name.toLowerCase().contains(q) ||
            s.id.toLowerCase().contains(q) ||
            s.districtId.toLowerCase().contains(q) ||
            (s.location?.toLowerCase().contains(q) ?? false) ||
            s.type.displayName.toLowerCase().contains(q);
        if (!hit) return false;
      }
      // Category filter
      if (_activeCategory != null && s.type.category != _activeCategory) {
        return false;
      }
      // State filter
      if (_activeStateFilter != null && s.state != _activeStateFilter) {
        return false;
      }
      // Toggle filters
      if (_showOfflineOnly && s.state == SensorState.online) return false;
      if (_showAlertOnly && !(s.latestReading?.isAlert ?? false)) return false;
      return true;
    }).toList();

    // Sort
    list.sort((a, b) {
      int cmp;
      switch (_sortMode) {
        case SortMode.name:
          cmp = a.name.compareTo(b.name);
          break;
        case SortMode.category:
          cmp = a.type.category.compareTo(b.type.category);
          break;
        case SortMode.state:
          cmp = a.state.index.compareTo(b.state.index);
          break;
        case SortMode.battery:
          cmp = (a.batteryPercentage ?? 0).compareTo(b.batteryPercentage ?? 0);
          break;
        case SortMode.district:
          cmp = a.districtId.compareTo(b.districtId);
          break;
      }
      return _sortAsc ? cmp : -cmp;
    });

    return list;
  }

  // ── stats ─────────────────────────────────────────────────────────────
  int get _onlineCount =>
      _allSensors.where((s) => s.state == SensorState.online).length;
  int get _alertCount =>
      _allSensors.where((s) => s.latestReading?.isAlert == true).length;
  int get _offlineCount =>
      _allSensors.where((s) => s.state != SensorState.online).length;
  int get _lowBatCount =>
      _allSensors.where((s) => (s.batteryPercentage ?? 100) < 25).length;

  // ═══════════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, provider, _) {
        // Sync provider updates silently
        if (provider.sensors.isNotEmpty && !_isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && provider.sensors.length != _allSensors.length) {
              setState(() => _allSensors = provider.sensors);
            }
          });
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: _T.bg,
            body: Stack(
              children: [
                AnimatedBackground(pulse: _bgPulse),
                GridLines(),
                SafeArea(
                  child: Column(
                    children: [
                      Header(
                        onBack: () => Navigator.maybePop(context),
                        viewMode: _viewMode,
                        onToggleView: () => setState(
                          () => _viewMode = _viewMode == ViewMode.list
                              ? ViewMode.grid
                              : ViewMode.list,
                        ),
                        onToggleFilters: () => setState(
                          () => _showFiltersPanel = !_showFiltersPanel,
                        ),
                        filtersActive: _showFiltersPanel,
                        totalSensors: _allSensors.length,
                        onlineCount: _onlineCount,
                      ),
                      StatsBar(
                        total: _allSensors.length,
                        online: _onlineCount,
                        alerts: _alertCount,
                        offline: _offlineCount,
                        lowBat: _lowBatCount,
                        onFilterState: (s) => setState(
                          () => _activeStateFilter = _activeStateFilter == s
                              ? null
                              : s,
                        ),
                        activeState: _activeStateFilter,
                      ),
                      SearchBarWidget(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        sortMode: _sortMode,
                        sortAsc: _sortAsc,
                        onSortChanged: (m) => setState(() {
                          if (_sortMode == m) {
                            _sortAsc = !_sortAsc;
                          } else {
                            _sortMode = m;
                            _sortAsc = true;
                          }
                        }),
                      ),
                      CategoryChips(
                        active: _activeCategory,
                        onChange: (c) => setState(
                          () =>
                              _activeCategory = _activeCategory == c ? null : c,
                        ),
                        sensorsPerCat: {
                          for (final cat in categoryMeta.keys)
                            cat: _allSensors
                                .where((s) => s.type.category == cat)
                                .length,
                        },
                      ),
                      if (_showFiltersPanel)
                        FiltersPanel(
                          showOfflineOnly: _showOfflineOnly,
                          showAlertOnly: _showAlertOnly,
                          onToggleOffline: () => setState(
                            () => _showOfflineOnly = !_showOfflineOnly,
                          ),
                          onToggleAlert: () =>
                              setState(() => _showAlertOnly = !_showAlertOnly),
                        ),
                      Expanded(
                        child: _isLoading
                            ? LoadingShimmer(shimmer: _shimmerAnim)
                            : _filtered.isEmpty
                            ? EmptyState(query: _searchQuery)
                            : SensorBody(
                                sensors: _filtered,
                                viewMode: _viewMode,
                                entryAnim: _entryAnim,
                                scrollCtrl: _scrollCtrl,
                                pinnedSensor: _pinnedSensor,
                                onPin: (s) => setState(
                                  () => _pinnedSensor =
                                      _pinnedSensor?.id == s.id ? null : s,
                                ),
                                onNavigate: (s) =>
                                    _navigateToDetail(context, s),
                              ),
                      ),
                    ],
                  ),
                ),
                // Peek panel overlay
                if (_pinnedSensor != null)
                  PeekPanel(
                    sensor: _pinnedSensor!,
                    onClose: () => setState(() => _pinnedSensor = null),
                    onOpen: () => _navigateToDetail(context, _pinnedSensor!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext ctx, SensorModel sensor) {
    Navigator.pushNamed(ctx, '/sensor-detail', arguments: sensor);
  }
}
