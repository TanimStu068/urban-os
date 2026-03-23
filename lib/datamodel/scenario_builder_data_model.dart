import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'dart:math';

typedef C = AppColors;

// ─────────────────────────────────────────
//  ENUMS & DATA MODELS
// ─────────────────────────────────────────
enum ScenarioStatus { draft, active, completed, failed }

enum TriggerType { immediate, delayed, condition, timeBased }

enum ScenarioComplexity { simple, intermediate, advanced, expert }

extension ScenarioStatusX on ScenarioStatus {
  String get label {
    switch (this) {
      case ScenarioStatus.draft:
        return 'DRAFT';
      case ScenarioStatus.active:
        return 'ACTIVE';
      case ScenarioStatus.completed:
        return 'COMPLETED';
      case ScenarioStatus.failed:
        return 'FAILED';
    }
  }

  Color get color {
    switch (this) {
      case ScenarioStatus.draft:
        return C.yellow;
      case ScenarioStatus.active:
        return C.green;
      case ScenarioStatus.completed:
        return C.teal;
      case ScenarioStatus.failed:
        return C.red;
    }
  }
}

extension TriggerTypeX on TriggerType {
  String get label {
    switch (this) {
      case TriggerType.immediate:
        return 'IMMEDIATE';
      case TriggerType.delayed:
        return 'DELAYED';
      case TriggerType.condition:
        return 'CONDITION-BASED';
      case TriggerType.timeBased:
        return 'TIME-BASED';
    }
  }

  Color get color {
    switch (this) {
      case TriggerType.immediate:
        return C.red;
      case TriggerType.delayed:
        return C.orange;
      case TriggerType.condition:
        return C.cyan;
      case TriggerType.timeBased:
        return C.teal;
    }
  }
}

extension ScenarioComplexityX on ScenarioComplexity {
  String get label {
    switch (this) {
      case ScenarioComplexity.simple:
        return 'SIMPLE';
      case ScenarioComplexity.intermediate:
        return 'INTERMEDIATE';
      case ScenarioComplexity.advanced:
        return 'ADVANCED';
      case ScenarioComplexity.expert:
        return 'EXPERT';
    }
  }

  Color get color {
    switch (this) {
      case ScenarioComplexity.simple:
        return C.green;
      case ScenarioComplexity.intermediate:
        return C.cyan;
      case ScenarioComplexity.advanced:
        return C.orange;
      case ScenarioComplexity.expert:
        return C.red;
    }
  }

  int get stepCount {
    switch (this) {
      case ScenarioComplexity.simple:
        return 2;
      case ScenarioComplexity.intermediate:
        return 4;
      case ScenarioComplexity.advanced:
        return 8;
      case ScenarioComplexity.expert:
        return 16;
    }
  }
}

class ScenarioStep {
  final String id;
  final int order;
  final String title;
  final String action;
  final int delaySeconds;
  TriggerType trigger;

  ScenarioStep({
    required this.id,
    required this.order,
    required this.title,
    required this.action,
    required this.delaySeconds,
    required this.trigger,
  });
}

class Scenario {
  final String id;
  final String name;
  final String description;
  final ScenarioComplexity complexity;
  ScenarioStatus status;
  final DateTime createdAt;
  final int durationSeconds;
  int elapsedSeconds;
  final List<ScenarioStep> steps;
  final List<String> tags;
  final int successMetrics;
  bool isFavorite;

  Scenario({
    required this.id,
    required this.name,
    required this.description,
    required this.complexity,
    required this.status,
    required this.createdAt,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.steps,
    required this.tags,
    required this.successMetrics,
    this.isFavorite = false,
  });

  String get progressLabel =>
      '${(elapsedSeconds / durationSeconds * 100).toStringAsFixed(0)}%';
  double get progressPercent => (elapsedSeconds / durationSeconds).clamp(0, 1);

  String get timeRemaining {
    final remaining = durationSeconds - elapsedSeconds;
    if (remaining <= 0) return 'COMPLETE';
    if (remaining < 60) return '${remaining}s';
    return '${(remaining / 60).toStringAsFixed(1)}m';
  }
}

// ─────────────────────────────────────────
//  MOCK DATA FACTORY
// ─────────────────────────────────────────
final rng = Random(987);

List<Scenario> buildScenarios() {
  final now = DateTime.now();
  return [
    Scenario(
      id: 'SCEN-001',
      name: 'Multi-District Blackout',
      description: 'Cascading power failure simulation across 3 districts',
      complexity: ScenarioComplexity.advanced,
      status: ScenarioStatus.active,
      createdAt: now.subtract(const Duration(days: 2)),
      durationSeconds: 3600,
      elapsedSeconds: 1850,
      steps: [
        ScenarioStep(
          id: 'STEP-001',
          order: 1,
          title: 'Initial Grid Failure',
          action: 'Trigger power loss in Industrial Zone',
          delaySeconds: 0,
          trigger: TriggerType.immediate,
        ),
        ScenarioStep(
          id: 'STEP-002',
          order: 2,
          title: 'Cascade Effect',
          action: 'Secondary failure in Commercial District',
          delaySeconds: 120,
          trigger: TriggerType.delayed,
        ),
        ScenarioStep(
          id: 'STEP-003',
          order: 3,
          title: 'Backup Activation',
          action: 'Activate emergency generators',
          delaySeconds: 300,
          trigger: TriggerType.timeBased,
        ),
        ScenarioStep(
          id: 'STEP-004',
          order: 4,
          title: 'Recovery',
          action: 'Restore grid sections sequentially',
          delaySeconds: 600,
          trigger: TriggerType.timeBased,
        ),
      ],
      tags: ['POWER', 'CRITICAL', 'CASCADING'],
      successMetrics: 87,
      isFavorite: true,
    ),
    Scenario(
      id: 'SCEN-002',
      name: 'Fire Emergency Response',
      description: 'High-rise fire with evacuation procedures',
      complexity: ScenarioComplexity.advanced,
      status: ScenarioStatus.draft,
      createdAt: now.subtract(const Duration(days: 5)),
      durationSeconds: 2400,
      elapsedSeconds: 0,
      steps: [
        ScenarioStep(
          id: 'STEP-101',
          order: 1,
          title: 'Fire Detection',
          action: 'Activate fire detection sensors',
          delaySeconds: 0,
          trigger: TriggerType.immediate,
        ),
        ScenarioStep(
          id: 'STEP-102',
          order: 2,
          title: 'Alarm & Alert',
          action: 'Trigger building alarm system',
          delaySeconds: 30,
          trigger: TriggerType.delayed,
        ),
        ScenarioStep(
          id: 'STEP-103',
          order: 3,
          title: 'Evacuation Start',
          action: 'Begin controlled evacuation',
          delaySeconds: 90,
          trigger: TriggerType.delayed,
        ),
      ],
      tags: ['FIRE', 'SAFETY', 'EVACUATION'],
      successMetrics: 0,
    ),
    Scenario(
      id: 'SCEN-003',
      name: 'Weather Stress Test',
      description: 'Extreme weather event with infrastructure impact',
      complexity: ScenarioComplexity.intermediate,
      status: ScenarioStatus.completed,
      createdAt: now.subtract(const Duration(days: 10)),
      durationSeconds: 1800,
      elapsedSeconds: 1800,
      steps: [
        ScenarioStep(
          id: 'STEP-201',
          order: 1,
          title: 'Rainfall Increase',
          action: 'Increment rainfall simulation',
          delaySeconds: 0,
          trigger: TriggerType.immediate,
        ),
        ScenarioStep(
          id: 'STEP-202',
          order: 2,
          title: 'Drainage Activation',
          action: 'Activate drainage systems',
          delaySeconds: 180,
          trigger: TriggerType.delayed,
        ),
      ],
      tags: ['WEATHER', 'ENVIRONMENT', 'INFRASTRUCTURE'],
      successMetrics: 94,
    ),
    Scenario(
      id: 'SCEN-004',
      name: 'Peak Hour Traffic',
      description: 'Morning rush hour simulation with congestion management',
      complexity: ScenarioComplexity.simple,
      status: ScenarioStatus.draft,
      createdAt: now.subtract(const Duration(days: 3)),
      durationSeconds: 3600,
      elapsedSeconds: 0,
      steps: [
        ScenarioStep(
          id: 'STEP-301',
          order: 1,
          title: 'Traffic Surge',
          action: 'Increase vehicle count simulation',
          delaySeconds: 0,
          trigger: TriggerType.immediate,
        ),
      ],
      tags: ['TRAFFIC', 'CONGESTION', 'OPTIMIZATION'],
      successMetrics: 0,
    ),
  ];
}
