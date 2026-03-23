/// Sensor Type Enum - Comprehensive IoT sensor types across all systems
enum SensorType {
  // ────────────── TRAFFIC SENSORS ──────────────
  trafficFlow, // Vehicles per hour
  congestionLevel, // 0-100% congestion
  vehicleCount, // Total vehicles detected
  averageSpeed, // Average vehicle speed
  accidentDetector, // Accident detection
  parkingOccupancy, // Parking space usage
  roadCondition, // Road surface condition
  // ────────────── ENERGY SENSORS ──────────────
  powerConsumption, // kW consumption
  voltageLevel, // Voltage (V)
  energyGeneration, // Solar/renewable generation
  gridFrequency, // Grid frequency (Hz)
  temperatureSensor, // Temperature in C
  waterLevel, // Water level (m)
  waterFlow, // Water flow rate (L/min)
  flowMeter, // General flow meter
  // ────────────── ENVIRONMENT SENSORS ──────────────
  airQuality, // Air Quality Index (AQI)
  pollutionLevel, // Pollution concentration (μg/m³)
  temperature, // External temperature (°C)
  humidity, // Humidity level (%)
  windSpeed, // Wind speed (m/s)
  weatherCondition, // Weather state (rainy, sunny, etc)
  uvIndex, // UV radiation index
  noiseLevel, // Noise level (dB)
  // ────────────── SAFETY SENSORS ──────────────
  smokeDetector, // Smoke detection
  fireAlarm, // Fire detection
  emergencyButton, // Emergency SOS button
  crowdDensity, // People per square meter
  accessControl, // Door/gate access
  cctvActivity, // Camera activity/motion
  motionDetector, // Motion detection
  vibrationSensor, // Vibration/seismic
  // ────────────── OTHER SENSORS ──────────────
  humidityLevel, // General humidity
  pressureLevel, // Atmospheric pressure
  rainGauge, // Rainfall measurement
  lightIntensity, // Light level (lux)
  co2Level, // CO2 concentration (ppm)
  dustLevel, // Dust/particulate matter
}

/// Extension for SensorType utilities
extension SensorTypeExtension on SensorType {
  /// Get human-readable sensor name
  String get displayName {
    const nameMap = {
      SensorType.trafficFlow: 'Traffic Flow',
      SensorType.congestionLevel: 'Congestion Level',
      SensorType.vehicleCount: 'Vehicle Count',
      SensorType.averageSpeed: 'Average Speed',
      SensorType.accidentDetector: 'Accident Detector',
      SensorType.parkingOccupancy: 'Parking Occupancy',
      SensorType.roadCondition: 'Road Condition',
      SensorType.powerConsumption: 'Power Consumption',
      SensorType.voltageLevel: 'Voltage Level',
      SensorType.energyGeneration: 'Energy Generation',
      SensorType.gridFrequency: 'Grid Frequency',
      SensorType.temperatureSensor: 'Temperature',
      SensorType.waterLevel: 'Water Level',
      SensorType.waterFlow: 'Water Flow',
      SensorType.flowMeter: 'Flow Meter',
      SensorType.airQuality: 'Air Quality',
      SensorType.pollutionLevel: 'Pollution Level',
      SensorType.temperature: 'Temperature',
      SensorType.humidity: 'Humidity',
      SensorType.windSpeed: 'Wind Speed',
      SensorType.weatherCondition: 'Weather Condition',
      SensorType.uvIndex: 'UV Index',
      SensorType.noiseLevel: 'Noise Level',
      SensorType.smokeDetector: 'Smoke Detector',
      SensorType.fireAlarm: 'Fire Alarm',
      SensorType.emergencyButton: 'Emergency Button',
      SensorType.crowdDensity: 'Crowd Density',
      SensorType.accessControl: 'Access Control',
      SensorType.cctvActivity: 'CCTV Activity',
      SensorType.motionDetector: 'Motion Detector',
      SensorType.vibrationSensor: 'Vibration Sensor',
      SensorType.humidityLevel: 'Humidity Level',
      SensorType.pressureLevel: 'Pressure Level',
      SensorType.rainGauge: 'Rain Gauge',
      SensorType.lightIntensity: 'Light Intensity',
      SensorType.co2Level: 'CO₂ Level',
      SensorType.dustLevel: 'Dust Level',
    };
    return nameMap[this] ?? toString().split('.').last;
  }

  /// Get sensor category
  String get category {
    const categoryMap = {
      SensorType.trafficFlow: 'Traffic',
      SensorType.congestionLevel: 'Traffic',
      SensorType.vehicleCount: 'Traffic',
      SensorType.averageSpeed: 'Traffic',
      SensorType.accidentDetector: 'Traffic',
      SensorType.parkingOccupancy: 'Traffic',
      SensorType.roadCondition: 'Traffic',
      SensorType.powerConsumption: 'Energy',
      SensorType.voltageLevel: 'Energy',
      SensorType.energyGeneration: 'Energy',
      SensorType.gridFrequency: 'Energy',
      SensorType.temperatureSensor: 'Energy',
      SensorType.waterLevel: 'Energy',
      SensorType.waterFlow: 'Energy',
      SensorType.flowMeter: 'Energy',
      SensorType.airQuality: 'Environment',
      SensorType.pollutionLevel: 'Environment',
      SensorType.temperature: 'Environment',
      SensorType.humidity: 'Environment',
      SensorType.windSpeed: 'Environment',
      SensorType.weatherCondition: 'Environment',
      SensorType.uvIndex: 'Environment',
      SensorType.noiseLevel: 'Environment',
      SensorType.smokeDetector: 'Safety',
      SensorType.fireAlarm: 'Safety',
      SensorType.emergencyButton: 'Safety',
      SensorType.crowdDensity: 'Safety',
      SensorType.accessControl: 'Safety',
      SensorType.cctvActivity: 'Safety',
      SensorType.motionDetector: 'Safety',
      SensorType.vibrationSensor: 'Safety',
      SensorType.humidityLevel: 'Other',
      SensorType.pressureLevel: 'Other',
      SensorType.rainGauge: 'Other',
      SensorType.lightIntensity: 'Other',
      SensorType.co2Level: 'Other',
      SensorType.dustLevel: 'Other',
    };
    return categoryMap[this] ?? 'Other';
  }

  /// Get unit of measurement
  String get unit {
    const unitMap = {
      SensorType.trafficFlow: 'vehicles/hr',
      SensorType.congestionLevel: '%',
      SensorType.vehicleCount: 'count',
      SensorType.averageSpeed: 'km/h',
      SensorType.accidentDetector: 'boolean',
      SensorType.parkingOccupancy: '%',
      SensorType.roadCondition: 'status',
      SensorType.powerConsumption: 'kW',
      SensorType.voltageLevel: 'V',
      SensorType.energyGeneration: 'kWh',
      SensorType.gridFrequency: 'Hz',
      SensorType.temperatureSensor: '°C',
      SensorType.waterLevel: 'm',
      SensorType.waterFlow: 'L/min',
      SensorType.flowMeter: 'm³/h',
      SensorType.airQuality: 'AQI',
      SensorType.pollutionLevel: 'μg/m³',
      SensorType.temperature: '°C',
      SensorType.humidity: '%',
      SensorType.windSpeed: 'm/s',
      SensorType.weatherCondition: 'status',
      SensorType.uvIndex: 'index',
      SensorType.noiseLevel: 'dB',
      SensorType.smokeDetector: 'boolean',
      SensorType.fireAlarm: 'boolean',
      SensorType.emergencyButton: 'boolean',
      SensorType.crowdDensity: 'people/m²',
      SensorType.accessControl: 'boolean',
      SensorType.cctvActivity: 'boolean',
      SensorType.motionDetector: 'boolean',
      SensorType.vibrationSensor: 'g (gravitational)',
      SensorType.humidityLevel: '%',
      SensorType.pressureLevel: 'hPa',
      SensorType.rainGauge: 'mm',
      SensorType.lightIntensity: 'lux',
      SensorType.co2Level: 'ppm',
      SensorType.dustLevel: 'μg/m³',
    };
    return unitMap[this] ?? 'unit';
  }
}
