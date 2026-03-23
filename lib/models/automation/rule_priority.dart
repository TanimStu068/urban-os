import 'package:flutter/material.dart';
import 'package:urban_os/screens/enviroment/environment_dashboard_screen.dart';

enum RulePriority { critical, high, medium, low }

enum RuleStatus { active, inactive, triggered, error, testing }

enum RuleCategory { traffic, energy, environment, safety, water, public }

enum ConditionOp { gt, lt, eq, gte, lte, neq }

enum LogicOp { and, or }

// ──────────────────────────────
// RulePriority extension
// ──────────────────────────────
extension RulePriorityX on RulePriority {
  Color get color {
    switch (this) {
      case RulePriority.critical:
        return C.red;
      case RulePriority.high:
        return C.orange;
      case RulePriority.medium:
        return C.amber;
      case RulePriority.low:
        return C.teal;
    }
  }

  String get label => name.toUpperCase();

  int get order {
    switch (this) {
      case RulePriority.critical:
        return 4;
      case RulePriority.high:
        return 3;
      case RulePriority.medium:
        return 2;
      case RulePriority.low:
        return 1;
    }
  }

  String get description {
    switch (this) {
      case RulePriority.critical:
        return 'Immediate action required';
      case RulePriority.high:
        return 'High importance rule';
      case RulePriority.medium:
        return 'Moderate priority automation';
      case RulePriority.low:
        return 'Low impact background rule';
    }
  }

  IconData get icon {
    switch (this) {
      case RulePriority.critical:
        return Icons.warning_rounded;
      case RulePriority.high:
        return Icons.priority_high_rounded;
      case RulePriority.medium:
        return Icons.low_priority_rounded;
      case RulePriority.low:
        return Icons.label_outline_rounded;
    }
  }
}

extension RuleStatusX on RuleStatus {
  Color get color {
    switch (this) {
      case RuleStatus.active:
        return C.green;
      case RuleStatus.inactive:
        return C.mutedLt;
      case RuleStatus.triggered:
        return C.amber;
      case RuleStatus.error:
        return C.red;
      case RuleStatus.testing:
        return C.violet;
    }
  }

  String get label => name.toUpperCase();

  IconData get icon {
    switch (this) {
      case RuleStatus.active:
        return Icons.play_circle_outline_rounded;
      case RuleStatus.inactive:
        return Icons.pause_circle_outline_rounded;
      case RuleStatus.triggered:
        return Icons.bolt_rounded;
      case RuleStatus.error:
        return Icons.error_outline_rounded;
      case RuleStatus.testing:
        return Icons.science_outlined;
    }
  }
}

extension RuleCategoryX on RuleCategory {
  Color get color {
    switch (this) {
      case RuleCategory.traffic:
        return C.cyan;
      case RuleCategory.energy:
        return C.amber;
      case RuleCategory.environment:
        return C.green;
      case RuleCategory.safety:
        return C.red;
      case RuleCategory.water:
        return C.sky;
      case RuleCategory.public:
        return C.violet;
    }
  }

  String get label => name[0].toUpperCase() + name.substring(1);

  IconData get icon {
    switch (this) {
      case RuleCategory.traffic:
        return Icons.traffic_rounded;
      case RuleCategory.energy:
        return Icons.bolt_rounded;
      case RuleCategory.environment:
        return Icons.eco_rounded;
      case RuleCategory.safety:
        return Icons.security_rounded;
      case RuleCategory.water:
        return Icons.water_drop_rounded;
      case RuleCategory.public:
        return Icons.people_rounded;
    }
  }
}

extension ConditionOpX on ConditionOp {
  String get symbol {
    switch (this) {
      case ConditionOp.gt:
        return '>';
      case ConditionOp.lt:
        return '<';
      case ConditionOp.eq:
        return '==';
      case ConditionOp.gte:
        return '≥';
      case ConditionOp.lte:
        return '≤';
      case ConditionOp.neq:
        return '≠';
    }
  }
}
