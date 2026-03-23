import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/report_gen_data_model.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/widgets/report_generator/data_summary.dart';
import 'package:urban_os/widgets/report_generator/format_selector.dart';
import 'package:urban_os/widgets/report_generator/generate_button.dart';
import 'package:urban_os/widgets/report_generator/header.dart';
import 'package:urban_os/widgets/report_generator/history.dart';
import 'package:urban_os/widgets/report_generator/options.dart';
import 'package:urban_os/widgets/report_generator/period_selector.dart';
import 'package:urban_os/widgets/report_generator/progress_panel.dart';
import 'package:urban_os/widgets/report_generator/report_bg_painter.dart';
import 'package:urban_os/widgets/report_generator/title_field.dart';
import 'package:urban_os/widgets/report_generator/type_selector.dart';

typedef C = AppColors;

class ReportGeneratorScreen extends StatefulWidget {
  const ReportGeneratorScreen({super.key});

  @override
  State<ReportGeneratorScreen> createState() => _ReportGeneratorScreenState();
}

class _ReportGeneratorScreenState extends State<ReportGeneratorScreen>
    with TickerProviderStateMixin {
  ReportConfig _config = ReportConfig(
    types: {ReportType.summary, ReportType.alerts},
  );

  ReportStatus _status = ReportStatus.idle;
  double _generateProgress = 0.0;
  String _generateStep = '';
  final List<GeneratedReport> _history = [];

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _progressCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _titleCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _rng = Random(99);

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
      duration: const Duration(seconds: 8),
    )..repeat();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.05), end: Offset.zero));

    _titleCtrl.text = 'UrbanOS System Report';
    _entranceCtrl.forward();

    // Seed history with demo entries
    _history.addAll(_seedHistory());
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _progressCtrl.dispose();
    _entranceCtrl.dispose();
    _titleCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<GeneratedReport> _seedHistory() {
    final now = DateTime.now();
    return [
      GeneratedReport(
        id: 'RPT-001',
        title: 'Daily System Summary',
        config: ReportConfig(
          types: {ReportType.summary},
          format: ReportFormat.pdf,
          period: ReportPeriod.last24h,
        ),
        generatedAt: now.subtract(const Duration(hours: 2)),
        recordCount: 1203,
        sizeKb: 148,
      ),
      GeneratedReport(
        id: 'RPT-002',
        title: 'Weekly Alert Report',
        config: ReportConfig(
          types: {ReportType.alerts},
          format: ReportFormat.csv,
          period: ReportPeriod.last7d,
        ),
        generatedAt: now.subtract(const Duration(days: 1)),
        recordCount: 87,
        sizeKb: 42,
      ),
      GeneratedReport(
        id: 'RPT-003',
        title: 'Compliance Audit',
        config: ReportConfig(
          types: {ReportType.compliance, ReportType.events},
          format: ReportFormat.json,
          period: ReportPeriod.last30d,
        ),
        generatedAt: now.subtract(const Duration(days: 3)),
        recordCount: 4512,
        sizeKb: 891,
      ),
    ];
  }

  // GENERATE LOGIC

  Future<void> _startGenerate(LogProvider lp) async {
    if (_config.types.isEmpty) return;
    setState(() {
      _status = ReportStatus.generating;
      _generateProgress = 0;
    });

    final steps = [
      'Initializing report engine...',
      'Fetching log data...',
      'Applying filters...',
      'Aggregating metrics...',
      'Building charts...',
      'Rendering output...',
      'Finalizing...',
    ];

    for (int i = 0; i < steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _generateStep = steps[i];
        _generateProgress = (i + 1) / steps.length;
      });
      await Future.delayed(Duration(milliseconds: 300 + _rng.nextInt(400)));
    }

    // Create report record
    final alertCount = lp.alerts.length;
    final eventCount = lp.events.length;
    final record = GeneratedReport(
      id: 'RPT-${(900 + _history.length + 1).toString().padLeft(3, '0')}',
      title: _titleCtrl.text.isEmpty ? 'Generated Report' : _titleCtrl.text,
      config: _config,
      generatedAt: DateTime.now(),
      recordCount: alertCount + eventCount + _rng.nextInt(500),
      sizeKb: 50 + _rng.nextInt(800),
    );

    if (!mounted) return;
    setState(() {
      _status = ReportStatus.ready;
      _generateStep = 'Report ready!';
      _history.insert(0, record);
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _status = ReportStatus.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (ctx, lp, _) => Scaffold(
        backgroundColor: C.bg,
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _bgCtrl,
            _glowCtrl,
            _scanCtrl,
            _blinkCtrl,
            _entranceCtrl,
          ]),
          builder: (_, __) => Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ReportBgPainter(
                    _bgCtrl.value,
                    _scanCtrl.value,
                    _glowCtrl.value,
                  ),
                ),
              ),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideIn,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReportHeaderWidget(
                          logProvider: lp,
                          glowAnimation: _glowCtrl,
                          blinkAnimation: _blinkCtrl,
                        ),
                        // _buildHeader(lp),
                        Expanded(
                          child: CustomScrollView(
                            controller: _scrollCtrl,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: DataSummaryWidget(
                                  logProvider: lp,
                                  glowAnimation: _glowCtrl,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: ReportTypeSelectorWidget(
                                  selectedTypes: _config.types,
                                  onTypesChanged: (types) => setState(
                                    () => _config = _config.copyWith(
                                      types: types,
                                    ),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: ReportFormatSelectorWidget(
                                  selectedFormat: _config.format,
                                  onFormatChanged: (f) => setState(
                                    () => _config = _config.copyWith(format: f),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: ReportPeriodSelectorWidget(
                                  selectedPeriod: _config.period,
                                  onPeriodChanged: (p) => setState(
                                    () => _config = _config.copyWith(period: p),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: ReportOptionsWidget(
                                  config: _config,
                                  onConfigChanged: (newConfig) =>
                                      setState(() => _config = newConfig),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: ReportTitleFieldWidget(
                                  controller: _titleCtrl,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: GenerateReportWidget(
                                  titleController: _titleCtrl,
                                  config: _config,
                                  status: _status,
                                  glowAnimation: _glowCtrl,
                                  onGenerate: () => _startGenerate(lp),
                                ),
                              ),
                              if (_status == ReportStatus.generating ||
                                  _status == ReportStatus.ready)
                                SliverToBoxAdapter(
                                  child: ProgressPanelWidget(
                                    status: _status,
                                    generateProgress: _generateProgress,
                                    generateStep: _generateStep,
                                    blinkAnimation: _blinkCtrl,
                                    onDismiss: () => setState(
                                      () => _status = ReportStatus.idle,
                                    ),
                                  ),
                                ),
                              SliverToBoxAdapter(
                                child: HistoryWidget(history: _history),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 32),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
