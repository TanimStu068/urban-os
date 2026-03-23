import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:urban_os/loader/mock_data_loader.dart';

import 'package:urban_os/models/district/district_model.dart';
import 'package:urban_os/models/district/district_metrics.dart';
import 'package:urban_os/models/district/district_type.dart';

class DistrictProvider with ChangeNotifier {
  final MockDataLoader _loader;

  List<DistrictModel> _districts = [];
  bool _isLoading = false;

  DistrictProvider(this._loader);

  /// -----------------------------
  /// GETTERS
  /// -----------------------------

  List<DistrictModel> get districts => List.unmodifiable(_districts);

  bool get isLoading => _isLoading;

  int get totalDistricts => _districts.length;

  DistrictModel? getDistrict(String id) =>
      _districts.firstWhereOrNull((d) => d.id == id);

  /// Average health score across districts
  double get averageHealthScore {
    if (_districts.isEmpty) return 0;

    final total = _districts
        .map((d) => d.metrics.overallHealthScore)
        .reduce((a, b) => a + b);

    return total / _districts.length;
  }

  /// Count districts with critical issues
  int get criticalDistrictCount =>
      _districts.where((d) => d.metrics.hasCriticalIssues).length;

  /// Total active incidents across districts
  int get totalActiveIncidents =>
      _districts.fold(0, (sum, d) => sum + d.metrics.activeIncidents);

  /// -----------------------------
  /// LOAD DATA
  /// -----------------------------

  Future<void> loadDistricts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _districts = await _loader.loadDistricts();
    } catch (e) {
      debugPrint("Failed to load districts: $e");
      _districts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// -----------------------------
  /// UPDATE DISTRICT METRICS
  /// -----------------------------

  void updateDistrictMetrics(String districtId, DistrictMetrics metrics) {
    final index = _districts.indexWhere((d) => d.id == districtId);

    if (index == -1) return;

    final updated = _districts[index].copyWith(metrics: metrics);

    _districts[index] = updated;

    notifyListeners();
  }

  /// -----------------------------
  /// UPDATE INCIDENT COUNT
  /// -----------------------------

  void updateIncidents(String districtId, int incidents) {
    final district = getDistrict(districtId);
    if (district == null) return;

    final updatedMetrics = district.metrics.copyWith(
      activeIncidents: incidents,
      lastUpdated: DateTime.now(),
    );

    updateDistrictMetrics(districtId, updatedMetrics);
  }

  /// -----------------------------
  /// DISTRICT TYPE FILTERS
  /// -----------------------------

  /// Generic filter (best production design)
  List<DistrictModel> getDistrictsByType(DistrictType type) {
    return _districts.where((d) => d.type == type).toList();
  }

  /// Group districts by type
  Map<DistrictType, List<DistrictModel>> get districtsByType {
    return groupBy(_districts, (DistrictModel d) => d.type);
  }

  /// Residential districts
  List<DistrictModel> get residentialDistricts =>
      _districts.where((d) => d.type.isResidential).toList();

  /// Industrial districts
  List<DistrictModel> get industrialDistricts =>
      _districts.where((d) => d.type.isIndustrial).toList();

  /// Commercial districts
  List<DistrictModel> get commercialDistricts =>
      _districts.where((d) => d.type.isCommercial).toList();

  /// Districts needing attention
  List<DistrictModel> get districtsNeedingAttention =>
      _districts.where((d) => d.needsAttention).toList();

  /// -----------------------------
  /// ANALYTICS
  /// -----------------------------

  Map<DistrictType, int> get districtTypeCounts {
    final Map<DistrictType, int> counts = {};

    for (var district in _districts) {
      counts[district.type] = (counts[district.type] ?? 0) + 1;
    }

    return counts;
  }

  /// -----------------------------
  /// REFRESH
  /// -----------------------------

  Future<void> refresh() async {
    await loadDistricts();
  }

  /// -----------------------------
  /// CLEAR
  /// -----------------------------

  void clear() {
    _districts = [];
    notifyListeners();
  }
}
