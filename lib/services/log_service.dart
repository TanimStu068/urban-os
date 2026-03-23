import 'package:flutter/foundation.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/models/logs/alert_log.dart';
import 'package:urban_os/models/logs/event_log.dart';
import 'package:urban_os/models/logs/system_log.dart';

class LogService with ChangeNotifier {
  final List<AlertLog> _alerts = [];
  final List<EventLog> _events = [];
  final List<SystemLog> _systemLogs = [];

  /// -------------------------------
  /// ALERTS
  /// -------------------------------
  List<AlertLog> get alerts => List.unmodifiable(_alerts);

  void addAlert(AlertLog alert) {
    _alerts.add(alert);
    notifyListeners();
  }

  void resolveAlert(String alertId, {String? userId, String? notes}) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      final old = _alerts[index];
      _alerts[index] = AlertLog(
        id: old.id,
        title: old.title,
        description: old.description,
        severity: old.severity,
        timestamp: old.timestamp,
        createdAt: old.createdAt,
        resolvedByUserId: userId,
        resolvedAt: DateTime.now(),
        resolutionNotes: notes,
        resourceId: old.resourceId,
        resourceType: old.resourceType,
        ruleId: old.ruleId,
        isActive: false,
        occurrenceCount: old.occurrenceCount,
      );
      notifyListeners();
    }
  }

  /// -------------------------------
  /// EVENTS
  /// -------------------------------
  List<EventLog> get events => List.unmodifiable(_events);

  void addEvent(EventLog event) {
    _events.add(event);
    notifyListeners();
  }

  /// -------------------------------
  /// SYSTEM LOGS
  /// -------------------------------
  List<SystemLog> get systemLogs => List.unmodifiable(_systemLogs);

  void addSystemLog(SystemLog log) {
    _systemLogs.add(log);
    notifyListeners();
  }

  /// -------------------------------
  /// CLEAR LOGS
  /// -------------------------------
  void clearAll() {
    _alerts.clear();
    _events.clear();
    _systemLogs.clear();
    notifyListeners();
  }

  /// Filter helpers
  List<AlertLog> alertsBySeverity(List<RulePriority> severities) =>
      _alerts.where((a) => severities.contains(a.severity)).toList();

  List<EventLog> eventsByLevel(List<EventLogLevel> levels) =>
      _events.where((e) => levels.contains(e.level)).toList();
}
