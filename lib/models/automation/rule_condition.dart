/// Comparison operators for rule conditions
enum ComparisonOperator {
  /// Sensor value is greater than threshold
  greaterThan,

  /// Sensor value is less than threshold
  lessThan,

  /// Sensor value equals threshold
  equalTo,

  /// Sensor value is greater than or equal to threshold
  greaterOrEqual,

  /// Sensor value is less than or equal to threshold
  lessOrEqual,

  /// Sensor value is not equal to threshold
  notEqual,

  /// Value is within a range (between)
  between,
}

/// Extension for ComparisonOperator utilities
extension ComparisonOperatorExtension on ComparisonOperator {
  /// Get symbolic representation
  String get symbol {
    const symbolMap = {
      ComparisonOperator.greaterThan: '>',
      ComparisonOperator.lessThan: '<',
      ComparisonOperator.equalTo: '==',
      ComparisonOperator.greaterOrEqual: '>=',
      ComparisonOperator.lessOrEqual: '<=',
      ComparisonOperator.notEqual: '!=',
      ComparisonOperator.between: '∈',
    };
    return symbolMap[this] ?? '?';
  }

  /// Get human-readable name
  String get displayName {
    const nameMap = {
      ComparisonOperator.greaterThan: 'Is Greater Than',
      ComparisonOperator.lessThan: 'Is Less Than',
      ComparisonOperator.equalTo: 'Equals',
      ComparisonOperator.greaterOrEqual: 'Is Greater Or Equal',
      ComparisonOperator.lessOrEqual: 'Is Less Or Equal',
      ComparisonOperator.notEqual: 'Is Not Equal',
      ComparisonOperator.between: 'Is Between',
    };
    return nameMap[this] ?? 'Unknown';
  }

  /// Check if a value satisfies the condition
  bool evaluate(double value, double threshold, [double? maxThreshold]) {
    switch (this) {
      case ComparisonOperator.greaterThan:
        return value > threshold;
      case ComparisonOperator.lessThan:
        return value < threshold;
      case ComparisonOperator.equalTo:
        return (value - threshold).abs() < 0.01; // Float comparison tolerance
      case ComparisonOperator.greaterOrEqual:
        return value >= threshold;
      case ComparisonOperator.lessOrEqual:
        return value <= threshold;
      case ComparisonOperator.notEqual:
        return (value - threshold).abs() >= 0.01;
      case ComparisonOperator.between:
        if (maxThreshold == null) return false;
        return value >= threshold && value <= maxThreshold;
    }
  }
}

/// Represents a single condition in a rule's IF clause
///
/// A condition checks if a sensor's value meets a criteria
class RuleCondition {
  /// ID of the sensor being monitored
  final String sensorId;

  /// Operator for comparison
  final ComparisonOperator operatorType;

  /// Threshold value to compare against
  final double threshold;

  /// Maximum threshold (used for 'between' operator)
  final double? maxThreshold;

  /// Optional description of this condition
  final String? description;

  /// Whether this condition must be satisfied (AND) or any (OR)
  final bool isRequired;

  /// Historical duration to evaluate (e.g., "average over last 5 minutes")
  final Duration? evaluationWindow;

  const RuleCondition({
    required this.sensorId,
    required this.operatorType,
    required this.threshold,
    this.maxThreshold,
    this.description,
    this.isRequired = true,
    this.evaluationWindow,
  });

  /// Create a copy with optional field overrides
  RuleCondition copyWith({
    String? sensorId,
    ComparisonOperator? operatorType,
    double? threshold,
    double? maxThreshold,
    String? description,
    bool? isRequired,
    Duration? evaluationWindow,
  }) {
    return RuleCondition(
      sensorId: sensorId ?? this.sensorId,
      operatorType: operatorType ?? this.operatorType,
      threshold: threshold ?? this.threshold,
      maxThreshold: maxThreshold ?? this.maxThreshold,
      description: description ?? this.description,
      isRequired: isRequired ?? this.isRequired,
      evaluationWindow: evaluationWindow ?? this.evaluationWindow,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'operator': operatorType.toString().split('.').last,
      'threshold': threshold,
      'maxThreshold': maxThreshold,
      'description': description,
      'isRequired': isRequired,
      'evaluationWindow': evaluationWindow?.inSeconds,
    };
  }

  /// Create from JSON
  factory RuleCondition.fromJson(Map<String, dynamic> json) {
    return RuleCondition(
      sensorId: json['sensorId'] ?? '',
      operatorType: _operatorFromString(json['operator']),
      threshold: (json['threshold'] as num?)?.toDouble() ?? 0.0,
      maxThreshold: (json['maxThreshold'] as num?)?.toDouble(),
      description: json['description'],
      isRequired: json['isRequired'] ?? true,
      evaluationWindow: json['evaluationWindow'] != null
          ? Duration(seconds: json['evaluationWindow'] as int)
          : null,
    );
  }

  /// Check if condition is satisfied given a current sensor value
  bool isSatisfied(double sensorValue) {
    return operatorType.evaluate(sensorValue, threshold, maxThreshold);
  }

  /// Get human-readable condition description
  String getReadableDescription(String sensorName) {
    return '$sensorName ${operatorType.symbol} $threshold';
  }

  @override
  String toString() => 'Condition: $sensorId ${operatorType.symbol} $threshold';
}

/// Helper to parse ComparisonOperator from string
ComparisonOperator _operatorFromString(String? value) {
  if (value == null) return ComparisonOperator.greaterThan;
  for (final op in ComparisonOperator.values) {
    if (op.toString().split('.').last == value) return op;
  }
  return ComparisonOperator.greaterThan;
}
