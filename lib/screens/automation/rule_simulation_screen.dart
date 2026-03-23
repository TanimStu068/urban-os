import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_condition.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/datamodel/rule_simulation_data_model.dart';
import 'package:urban_os/widgets/rule_simulation/bg_painter.dart';
import 'package:urban_os/widgets/rule_simulation/control_panel.dart';
import 'package:urban_os/widgets/rule_simulation/rule_selector_panel.dart';
import 'package:urban_os/widgets/rule_simulation/rule_sim_header.dart';
import 'package:urban_os/widgets/rule_simulation/sensor_panel.dart';
import 'package:urban_os/widgets/rule_simulation/sim_config_panel.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_actuator_panel.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_condition_eval.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_line_chart.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_log_panel.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_progress_bar.dart';
import 'package:urban_os/widgets/rule_simulation/simulation_result_summary.dart';

typedef C = AppColors;

//  SCREEN
// ─────────────────────────────────────────
class RuleSimulationScreen extends StatefulWidget {
  final AutomationRule? initialRule;
  const RuleSimulationScreen({super.key, this.initialRule});
  @override
  State<RuleSimulationScreen> createState() => _RuleSimulationScreenState();
}

class _RuleSimulationScreenState extends State<RuleSimulationScreen>
    with TickerProviderStateMixin {
  AutomationRule? _selectedRule;
  SimPhase _phase = SimPhase.idle;
  SimSpeed _speed = SimSpeed.normal;
  SimScenario _scenario = SimScenario.custom;
  int _totalTicks = 30;
  int _currentTick = 0;
  int _triggerCount = 0;
  int _ticksSinceTrigger = 0;
  bool _noiseEnabled = true;
  double _noiseAmp = 0.08;

  List<SimSensor> _sensors = [];
  List<SimActuator> _actuators = [];
  List<SimTick> _ticks = [];
  final List<SimLogEntry> _log = [];
  List<bool> _condResults = [];
  bool _condMet = false;
  bool _ruleFired = false;

  DateTime? _simStart;
  DateTime? _simEnd;

  final _rnd = Random();

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _fireCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();
  final _logScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _fireCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
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
    ).drive(Tween(begin: const Offset(0, 0.05), end: Offset.zero));

    _entranceCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AutomationProvider>();
      final rules = provider.rules;
      if (widget.initialRule != null) {
        _selectedRule = widget.initialRule;
      } else if (rules.isNotEmpty) {
        _selectedRule = rules.first;
      }
      if (_selectedRule != null) _buildSimInputs();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _fireCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    _logScrollCtrl.dispose();
    super.dispose();
  }

  void _buildSimInputs() {
    if (_selectedRule == null) return;
    _sensors = _selectedRule!.conditions.map((c) {
      const defaultMax = 200.0;
      const defaultMin = 0.0;
      double startVal =
          (c.operatorType == ComparisonOperator.greaterThan ||
              c.operatorType == ComparisonOperator.greaterOrEqual)
          ? c.threshold * 0.65
          : c.threshold * 1.4;
      startVal = startVal.clamp(defaultMin, defaultMax);
      return SimSensor(
        sensorId: c.sensorId,
        value: startVal,
        minRange: defaultMin,
        maxRange: defaultMax,
        condition: c,
      );
    }).toList();
    _actuators = _selectedRule!.actions
        .where((a) => a.actuatorId != null)
        .map((a) => SimActuator(id: a.actuatorId!))
        .toList();
    _condResults = List<bool>.filled(
      _selectedRule!.conditions.length,
      false,
      growable: true,
    );
    _condMet = false;
    _ruleFired = false;
  }

  void _startSim() {
    if (_selectedRule == null) return;
    setState(() {
      _phase = SimPhase.running;
      _currentTick = 0;
      _triggerCount = 0;
      _ticks.clear();
      _log.clear();
      _ticksSinceTrigger = 0;
      _simStart = DateTime.now();
      _simEnd = null;
      for (final a in _actuators) {
        a.triggered = false;
        a.triggerCount = 0;
      }
    });
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message: 'Simulation started — ${_selectedRule!.name}',
        level: SimLogLevel.info,
      ),
    );
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message:
            'Speed: ${_speed.label}  ·  Ticks: $_totalTicks  ·  Scenario: ${_scenario.label}  ·  Noise: ${_noiseEnabled ? 'ON' : 'OFF'}',
        level: SimLogLevel.info,
      ),
    );
    _scheduleTick();
  }

  void _scheduleTick() {
    Future.delayed(Duration(milliseconds: _speed.tickMs), () {
      if (!mounted || _phase != SimPhase.running) return;
      _doTick();
      if (_currentTick < _totalTicks && _phase == SimPhase.running) {
        _scheduleTick();
      } else if (_currentTick >= _totalTicks) {
        _finishSim();
      }
    });
  }

  void _doTick() {
    if (_phase != SimPhase.running) return;
    setState(() {
      _currentTick++;
      _ticksSinceTrigger++;

      // Apply scenario
      if (_scenario != SimScenario.custom) _applyScenario();

      // Apply noise
      if (_noiseEnabled) {
        for (final s in _sensors) {
          if (!s.manualOverride) {
            final noise =
                (_rnd.nextDouble() * 2 - 1) *
                _noiseAmp *
                (s.maxRange - s.minRange);
            s.value = (s.value + noise).clamp(s.minRange, s.maxRange);
          }
        }
      }

      // Evaluate conditions using the actual RuleCondition model
      final rule = _selectedRule!;
      final sensorMap = <String, double>{
        for (final s in _sensors) s.sensorId: s.value,
      };

      _condResults = List.generate(rule.conditions.length, (i) {
        final cond = rule.conditions[i];
        final val = sensorMap[cond.sensorId];
        if (val == null) return false;
        return cond.isSatisfied(val);
      });

      // Evaluate overall logic using model method
      _condMet = rule.areConditionsSatisfied(sensorMap);

      bool fired = false;
      if (_condMet) {
        _triggerCount++;
        _ticksSinceTrigger = 0;
        fired = true;
        for (final a in _actuators) {
          a.triggered = true;
          a.triggerCount++;
        }
        if (!_ruleFired) {
          _log.add(
            SimLogEntry(
              time: _fmtTime(DateTime.now()),
              message:
                  '🔥 Rule TRIGGERED at tick #$_currentTick — conditions met (${rule.conditionLogic})!',
              level: SimLogLevel.trigger,
            ),
          );
        }
        _ruleFired = true;
        _fireCtrl.forward(from: 0);
      } else {
        for (final a in _actuators) {
          a.triggered = false;
        }
        if (_ruleFired) {
          _log.add(
            SimLogEntry(
              time: _fmtTime(DateTime.now()),
              message: 'Rule deactivated at tick #$_currentTick',
              level: SimLogLevel.warning,
            ),
          );
        }
        _ruleFired = false;
      }

      _ticks.add(
        SimTick(
          tick: _currentTick,
          sensorValues: Map.from(sensorMap),
          conditionsMet: _condMet,
          ruleTriggered: fired,
        ),
      );

      if (_currentTick % 5 == 0) {
        final vals = _sensors
            .map((s) => '${s.sensorId}: ${s.value.toStringAsFixed(1)}')
            .join('  |  ');
        _log.add(
          SimLogEntry(
            time: _fmtTime(DateTime.now()),
            message: 'Tick #$_currentTick  ·  $vals',
            level: SimLogLevel.info,
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollCtrl.hasClients) {
        _logScrollCtrl.animateTo(
          _logScrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _applyScenario() {
    final t = _currentTick / _totalTicks;
    for (int i = 0; i < _sensors.length; i++) {
      if (_sensors[i].manualOverride || i >= _selectedRule!.conditions.length) {
        continue;
      }
      final cond = _selectedRule!.conditions[i];
      double target;
      switch (_scenario) {
        case SimScenario.rampUp:
          target = cond.threshold * (0.3 + t * 1.4);
          break;
        case SimScenario.pulse:
          final pulse = (sin(t * _totalTicks * pi / 4) + 1) / 2;
          target =
              _sensors[i].minRange +
              (_sensors[i].maxRange - _sensors[i].minRange) * pulse;
          break;
        case SimScenario.stress:
          target = t < 0.5
              ? cond.threshold * 0.9
              : t < 0.75
              ? cond.threshold * 1.5
              : cond.threshold * 0.7;
          break;
        default:
          return;
      }
      _sensors[i].value =
          (_sensors[i].value * 0.82 +
          target.clamp(_sensors[i].minRange, _sensors[i].maxRange) * 0.18);
    }
  }

  void _pauseSim() => setState(() => _phase = SimPhase.paused);

  void _resumeSim() {
    setState(() => _phase = SimPhase.running);
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message: 'Simulation resumed at tick #$_currentTick',
        level: SimLogLevel.info,
      ),
    );
    _scheduleTick();
  }

  void _stopSim() {
    setState(() {
      _phase = SimPhase.idle;
      _currentTick = 0;
      _triggerCount = 0;
      _ticks.clear();
      _log.clear();
    });
    _buildSimInputs();
  }

  void _finishSim() {
    _simEnd = DateTime.now();
    setState(() => _phase = SimPhase.completed);
    final dur = _simEnd!.difference(_simStart!);
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message:
            'Simulation COMPLETED — $_totalTicks ticks in ${dur.inSeconds}s',
        level: SimLogLevel.success,
      ),
    );
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message:
            'Trigger rate: $_triggerCount / $_totalTicks ticks (${(_triggerCount / _totalTicks * 100).toStringAsFixed(1)}%)',
        level: SimLogLevel.success,
      ),
    );

    // Log to provider
    if (mounted && _selectedRule != null) {
      context.read<AutomationProvider>().executeRule(
        _selectedRule!.id,
        logProvider: context.read<LogProvider>(),
        sensorValues: {for (final s in _sensors) s.sensorId: s.value},
      );
    }
  }

  void _injectState(String mode) {
    setState(() {
      for (int i = 0; i < _sensors.length; i++) {
        if (_sensors[i].manualOverride ||
            i >= _selectedRule!.conditions.length) {
          continue;
        }
        final cond = _selectedRule!.conditions[i];
        double val;
        switch (mode) {
          case 'trigger':
            val =
                cond.operatorType == ComparisonOperator.greaterThan ||
                    cond.operatorType == ComparisonOperator.greaterOrEqual
                ? cond.threshold * 1.25
                : cond.threshold * 0.65;
            break;
          case 'safe':
            val =
                cond.operatorType == ComparisonOperator.greaterThan ||
                    cond.operatorType == ComparisonOperator.greaterOrEqual
                ? cond.threshold * 0.55
                : cond.threshold * 1.45;
            break;
          case 'edge':
            val = cond.threshold;
            break;
          default:
            return;
        }
        _sensors[i].value = val.clamp(
          _sensors[i].minRange,
          _sensors[i].maxRange,
        );
      }
    });
    final label = mode == 'trigger'
        ? 'TRIGGER state'
        : mode == 'safe'
        ? 'SAFE state'
        : 'EDGE case';
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message: 'Injected: $label',
        level: SimLogLevel.warning,
      ),
    );
    setState(() {});
  }

  void handleValueChanged(int index, double value) {
    setState(() {
      _sensors[index].value = value;
      _sensors[index].manualOverride = true;
    });
  }

  void handleOverrideToggled(int index) {
    setState(() {
      _sensors[index].manualOverride = !_sensors[index].manualOverride;
    });
  }

  void _resetSensors() {
    _buildSimInputs();
    setState(() {});
    _log.add(
      SimLogEntry(
        time: _fmtTime(DateTime.now()),
        message: 'Sensors reset to defaults',
        level: SimLogLevel.info,
      ),
    );
  }

  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}.${(dt.millisecond ~/ 10).toString().padLeft(2, '0')}';
  double get _progress => _totalTicks > 0 ? _currentTick / _totalTicks : 0;

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(t: _bgCtrl.value),
              size: Size.infinite,
            ),
          ),
          AnimatedBuilder(
            animation: _scanCtrl,
            builder: (_, __) => Positioned(
              top: _scanCtrl.value * size.height,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.cyan.withOpacity(0.06),
                      C.cyan.withOpacity(0.1),
                      C.cyan.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _fireCtrl,
            builder: (_, __) => _fireCtrl.value > 0
                ? Positioned.fill(
                    child: Container(
                      color: C.violet.withOpacity(0.04 * (1 - _fireCtrl.value)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Consumer<AutomationProvider>(
                  builder: (_, provider, __) {
                    return Column(
                      children: [
                        RuleSimHeader(
                          phase: _phase, // current simulation phase
                          blinkAnimation:
                              _blinkCtrl, // your AnimationController
                          onBack: () {
                            Navigator.maybePop(
                              context,
                            ); // optional, can be null
                          },
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollCtrl,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RuleSelectorPanel(
                                  rules: provider
                                      .rules, // list of rules from provider
                                  selectedRule:
                                      _selectedRule, // currently selected rule
                                  glowAnimation:
                                      _glowCtrl, // your glow animation controller
                                  onRuleSelected: (rule) {
                                    setState(() {
                                      _selectedRule = rule;
                                    });
                                    _buildSimInputs(); // rebuild sensors/actuators for the selected rule
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: SimConfigPanel(
                                        totalTicks: _totalTicks,
                                        phase: _phase,
                                        speed: _speed,
                                        scenario: _scenario,
                                        noiseEnabled: _noiseEnabled,
                                        noiseAmp: _noiseAmp,
                                        onTotalTicksChanged: (val) =>
                                            setState(() => _totalTicks = val),
                                        onSpeedChanged: (val) =>
                                            setState(() => _speed = val),
                                        onScenarioChanged: (val) =>
                                            setState(() => _scenario = val),
                                        onNoiseToggled: () => setState(
                                          () => _noiseEnabled = !_noiseEnabled,
                                        ),
                                        onNoiseAmpChanged: (val) =>
                                            setState(() => _noiseAmp = val),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: ControlPanel(
                                        phase: _phase,
                                        currentTick: _currentTick,
                                        totalTicks: _totalTicks,
                                        triggerCount: _triggerCount,
                                        ticksSinceTrigger: _ticksSinceTrigger,
                                        glowAnimation: _glowCtrl,
                                        startSim: _startSim,
                                        pauseSim: _pauseSim,
                                        resumeSim: _resumeSim,
                                        stopSim: _stopSim,
                                        injectState: _injectState,
                                        resetSensors: _resetSensors,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SimulationProgressBar(
                                  phase: _phase,
                                  progress: _progress,
                                  currentTick: _currentTick,
                                  totalTicks: _totalTicks,
                                  glowAnimation: _glowCtrl,
                                  ticks: _ticks,
                                ),
                                const SizedBox(height: 12),
                                if (_sensors.isNotEmpty) ...[
                                  SensorPanel(
                                    sensors: _sensors,
                                    condResults: _condResults,
                                    condMet: _condMet,
                                    glowT: _glowCtrl.value,
                                    blinkT: _blinkCtrl.value,
                                    onValueChanged: (i, v) {
                                      setState(() {
                                        _sensors[i].value = v;
                                        _sensors[i].manualOverride = true;
                                      });
                                    },
                                    onOverrideToggled: (i) {
                                      setState(() {
                                        _sensors[i].manualOverride =
                                            !_sensors[i].manualOverride;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                SimulationConditionEval(
                                  selectedRule: _selectedRule,
                                  condMet: _condMet,
                                  condResults: _condResults,
                                  sensors: _sensors,
                                  glowCtrl: _glowCtrl,
                                  blinkCtrl: _blinkCtrl,
                                ),
                                const SizedBox(height: 12),
                                if (_actuators.isNotEmpty) ...[
                                  SimulationActuatorPanel(
                                    actuators: _actuators,
                                    ruleFired: _ruleFired,
                                    glowCtrl: _glowCtrl,
                                    blinkCtrl: _blinkCtrl,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                if (_ticks.isNotEmpty) ...[
                                  SimulationTimelineChart(
                                    ticks: _ticks,
                                    sensors: _sensors,
                                    rule: _selectedRule,
                                    glowCtrl: _glowCtrl,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                if (_phase == SimPhase.completed) ...[
                                  SimulationResultSummary(
                                    glowCtrl: _glowCtrl,
                                    totalTicks: _ticks.length,
                                    triggerCount: _triggerCount,
                                    simStart: _simStart,
                                    simEnd: _simEnd,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                SimulationLogPanel(
                                  log: _log, // ✅ use the correct list
                                  logScrollCtrl:
                                      _logScrollCtrl, // also use the correct ScrollController
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
