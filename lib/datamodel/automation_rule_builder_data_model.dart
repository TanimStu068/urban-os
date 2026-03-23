import 'package:urban_os/models/automation/rule_action.dart';
import 'package:urban_os/models/automation/rule_condition.dart';

enum BuilderStep { identity, conditions, actions, schedule, review }

//  DRAFT MODELS (for mutable builder state)
class DraftCondition {
  String id;
  String sensorId;
  ComparisonOperator operatorType;
  double threshold;
  double? maxThreshold;
  String description;
  bool isRequired;

  DraftCondition({
    required this.id,
    this.sensorId = '',
    this.operatorType = ComparisonOperator.greaterThan,
    this.threshold = 0,
    this.maxThreshold,
    this.description = '',
    this.isRequired = true,
  });

  RuleCondition toModel() => RuleCondition(
    sensorId: sensorId,
    operatorType: operatorType,
    threshold: threshold,
    maxThreshold: maxThreshold,
    description: description.isNotEmpty ? description : null,
    isRequired: isRequired,
  );
}

class DraftAction {
  String id;
  ActionType type;
  String? actuatorId;
  double? targetValue;
  String? notificationMessage;
  String? notificationSeverity;
  String? eventDescription;
  bool isEnabled;

  DraftAction({
    required this.id,
    this.type = ActionType.setActuatorState,
    this.actuatorId,
    this.targetValue,
    this.notificationMessage,
    this.notificationSeverity,
    this.eventDescription,
    this.isEnabled = true,
  });

  RuleAction toModel() => RuleAction(
    id: id,
    type: type,
    actuatorId: actuatorId,
    targetValue: targetValue,
    notificationMessage: notificationMessage,
    notificationSeverity: notificationSeverity,
    eventDescription: eventDescription,
    isEnabled: isEnabled,
  );
}

const sensorOptions = [
  'TEMP-01',
  'TEMP-02',
  'HUMID-01',
  'AQI-IND-01',
  'AQI-IND-02',
  'VEH-RD4-01',
  'SPD-RD4-01',
  'CROWD-RES',
  'PWR-GRID-01',
  'FIRE-01',
  'WATER-FLOW-01',
  'WATER-LEVEL-01',
  'TIME-01',
  'NOISE-01',
  'CO2-01',
  'PRESSURE-01',
];
const actuatorOptions = [
  'TL-01',
  'TL-06',
  'TL-ALL',
  'LIGHT-RES',
  'LIGHT-COM',
  'FILT-01',
  'FILT-02',
  'GRID-SW-NC',
  'GEN-01',
  'SIREN-01',
  'EXITS-01',
  'SPD-SIGN-01',
  'NOTIF-01',
  'NOTIF-02',
  'NOTIF-EMER',
  'PUMP-01',
  'VALVE-01',
];
const districts = [
  'All Districts',
  'Industrial District',
  'Residential District',
  'Commercial District',
  'Green Zone',
  'Port Zone',
  'City Center',
];
