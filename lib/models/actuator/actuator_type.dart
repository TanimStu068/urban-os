/// Types of controllable actuators in the UrbanOS system
enum ActuatorType {
  // ────────────── TRAFFIC CONTROL ──────────────
  /// Traffic light controller
  trafficLight,

  /// Dynamic speed limit display
  speedLimitBoard,

  /// Lane control system (reversible lanes, etc)
  laneControl,

  /// Adaptive traffic signal
  adaptiveSignal,

  // ────────────── STREET LIGHTING ──────────────
  /// Street light with dimming capability
  streetLight,

  /// Decorative/accent lighting
  decorativeLight,

  /// Emergency/backup lighting
  emergencyLight,

  // ────────────── WATER MANAGEMENT ──────────────
  /// Pumping system for water distribution
  waterPump,

  /// Irrigation system controller
  irrigationSystem,

  /// Flood gate/barrier control
  floodGate,

  /// Water treatment valve controller
  treatmentValve,

  // ────────────── ENERGY MANAGEMENT ──────────────
  /// Power distribution switch/breaker
  powerSwitch,

  /// Backup power generator
  backupGenerator,

  /// Energy storage system (battery)
  energyStorage,

  /// Solar panel system controller
  solarController,

  // ────────────── ENVIRONMENTAL CONTROL ──────────────
  /// Air filtration system
  airFilter,

  /// Air conditioning/HVAC system
  hvacSystem,

  /// Ventilation fan
  ventilationFan,

  /// Pollution control unit
  pollutionControl,

  // ────────────── SAFETY & SECURITY ──────────────
  /// Emergency alarm/siren
  emergencySiren,

  /// Public notification system (loudspeaker)
  notificationSystem,

  /// Access control gate/barrier
  accessControl,

  /// Fire suppression system
  fireSuppressionSystem,

  /// Security door lock
  securityLock,

  // ────────────── TRANSPORTATION ──────────────
  /// Automatic transport rerouting system
  transportRerouting,

  /// Parking guidance system
  parkingGuidance,

  /// Public transport control
  publicTransportControl,

  // ────────────── MISCELLANEOUS ──────────────
  /// Generic switch actuator
  genericSwitch,

  /// Generic dimming control
  dimmerControl,

  /// Generic valve controller
  valveControl,
}

/// Extension for ActuatorType utilities
extension ActuatorTypeExtension on ActuatorType {
  /// Get human-readable actuator name
  String get displayName {
    const nameMap = {
      ActuatorType.trafficLight: 'Traffic Light',
      ActuatorType.speedLimitBoard: 'Speed Limit Board',
      ActuatorType.laneControl: 'Lane Control',
      ActuatorType.adaptiveSignal: 'Adaptive Signal',
      ActuatorType.streetLight: 'Street Light',
      ActuatorType.decorativeLight: 'Decorative Light',
      ActuatorType.emergencyLight: 'Emergency Light',
      ActuatorType.waterPump: 'Water Pump',
      ActuatorType.irrigationSystem: 'Irrigation System',
      ActuatorType.floodGate: 'Flood Gate',
      ActuatorType.treatmentValve: 'Treatment Valve',
      ActuatorType.powerSwitch: 'Power Switch',
      ActuatorType.backupGenerator: 'Backup Generator',
      ActuatorType.energyStorage: 'Energy Storage',
      ActuatorType.solarController: 'Solar Controller',
      ActuatorType.airFilter: 'Air Filter',
      ActuatorType.hvacSystem: 'HVAC System',
      ActuatorType.ventilationFan: 'Ventilation Fan',
      ActuatorType.pollutionControl: 'Pollution Control',
      ActuatorType.emergencySiren: 'Emergency Siren',
      ActuatorType.notificationSystem: 'Notification System',
      ActuatorType.accessControl: 'Access Control',
      ActuatorType.fireSuppressionSystem: 'Fire Suppression',
      ActuatorType.securityLock: 'Security Lock',
      ActuatorType.transportRerouting: 'Transport Rerouting',
      ActuatorType.parkingGuidance: 'Parking Guidance',
      ActuatorType.publicTransportControl: 'Public Transport Control',
      ActuatorType.genericSwitch: 'Generic Switch',
      ActuatorType.dimmerControl: 'Dimmer Control',
      ActuatorType.valveControl: 'Valve Control',
    };
    return nameMap[this] ?? 'Unknown Actuator';
  }

  /// Get category for grouping/filtering
  String get category {
    if ([
      ActuatorType.trafficLight,
      ActuatorType.speedLimitBoard,
      ActuatorType.laneControl,
      ActuatorType.adaptiveSignal,
    ].contains(this)) {
      return 'Traffic Control';
    }
    if ([
      ActuatorType.streetLight,
      ActuatorType.decorativeLight,
      ActuatorType.emergencyLight,
    ].contains(this)) {
      return 'Lighting';
    }
    if ([
      ActuatorType.waterPump,
      ActuatorType.irrigationSystem,
      ActuatorType.floodGate,
      ActuatorType.treatmentValve,
    ].contains(this)) {
      return 'Water Management';
    }
    if ([
      ActuatorType.powerSwitch,
      ActuatorType.backupGenerator,
      ActuatorType.energyStorage,
      ActuatorType.solarController,
    ].contains(this)) {
      return 'Energy Management';
    }
    if ([
      ActuatorType.airFilter,
      ActuatorType.hvacSystem,
      ActuatorType.ventilationFan,
      ActuatorType.pollutionControl,
    ].contains(this)) {
      return 'Environmental Control';
    }
    if ([
      ActuatorType.emergencySiren,
      ActuatorType.notificationSystem,
      ActuatorType.accessControl,
      ActuatorType.fireSuppressionSystem,
      ActuatorType.securityLock,
    ].contains(this)) {
      return 'Safety & Security';
    }
    if ([
      ActuatorType.transportRerouting,
      ActuatorType.parkingGuidance,
      ActuatorType.publicTransportControl,
    ].contains(this)) {
      return 'Transportation';
    }
    return 'Miscellaneous';
  }

  /// Get all actuators by category
  static Map<String, List<ActuatorType>> get byCategory {
    final map = <String, List<ActuatorType>>{};
    for (final actuator in ActuatorType.values) {
      final cat = actuator.category;
      map.putIfAbsent(cat, () => []).add(actuator);
    }
    return map;
  }
}
