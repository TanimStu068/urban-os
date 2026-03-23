import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/models/automation/automation_rule.dart';
import 'package:urban_os/models/automation/rule_priority.dart';
import 'package:urban_os/providers/automation/automation_provider.dart';
import 'package:urban_os/providers/log/log_provider.dart';
import 'package:urban_os/screens/automation/rule_builder_screen.dart';
import 'package:urban_os/screens/automation/rule_simulation_screen.dart';
import 'package:urban_os/widgets/automation_rule/automation_header.dart';
import 'package:urban_os/widgets/automation_rule/bg_painter.dart';
import 'package:urban_os/widgets/automation_rule/glowing_fab.dart';
import 'package:urban_os/widgets/automation_rule/rule_list.dart';
import 'package:urban_os/widgets/automation_rule/rule_search_and_filter.dart';
import 'package:urban_os/widgets/automation_rule/rule_sort_bar.dart';
import 'package:urban_os/widgets/automation_rule/rule_summary.dart';

const kAccent = AppColors.cyan;
typedef C = AppColors;

class AutomationRuleListScreen extends StatefulWidget {
  const AutomationRuleListScreen({super.key});

  @override
  State<AutomationRuleListScreen> createState() => _AutomationRuleListState();
}

class _AutomationRuleListState extends State<AutomationRuleListScreen>
    with TickerProviderStateMixin {
  // Filters
  RuleCategory? _catFilter;
  RulePriority? _priFilter;
  RuleStatus? _statFilter;
  String _searchQuery = '';
  int _sortMode = 0; // 0=priority 1=triggered 2=name 3=category

  // Expansion state
  String? _expandedId;

  // Animation controllers
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _blinkCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

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
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text),
    );
    _entranceCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutomationProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _blinkCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Filter + sort pipeline ──
  List<AutomationRule> _getFiltered(List<AutomationRule> rules) {
    var result = rules.toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (r) =>
                r.name.toLowerCase().contains(q) ||
                r.id.toLowerCase().contains(q) ||
                r.district.toLowerCase().contains(q) ||
                (r.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    if (_catFilter != null) {
      result = result.where((r) => r.category == _catFilter).toList();
    }
    if (_priFilter != null) {
      result = result.where((r) => r.priority == _priFilter).toList();
    }
    if (_statFilter != null) {
      result = result.where((r) => r.status == _statFilter).toList();
    }
    switch (_sortMode) {
      case 0:
        result.sort((a, b) => b.priority.order.compareTo(a.priority.order));
        break;
      case 1:
        result.sort((a, b) => b.triggerCount.compareTo(a.triggerCount));
        break;
      case 2:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 3:
        result.sort(
          (a, b) => (a.category?.index ?? 0).compareTo(b.category?.index ?? 0),
        );
        break;
    }
    return result;
  }

  void _deleteRule(AutomationRule rule) {
    context.read<AutomationProvider>().deleteRule(rule);
    _showSnack('Rule ${rule.id} deleted');
  }

  void _duplicateRule(AutomationRule rule) {
    final newRule = context.read<AutomationProvider>().duplicateRule(rule);
    if (newRule != null) _showSnack('Rule duplicated as ${newRule.id}');
  }

  void _testRule(AutomationRule rule) {
    context.read<AutomationProvider>().testRule(rule.id);
    _showSnack('Testing ${rule.id}…');
  }

  void _toggleRule(AutomationRule rule) {
    context.read<AutomationProvider>().toggleRule(rule);
  }

  void _executeRule(AutomationRule rule) {
    final logProvider = context.read<LogProvider>();
    final success = context.read<AutomationProvider>().executeRule(
      rule.id,
      logProvider: logProvider,
    );
    _showSnack(
      success
          ? '✓ Rule ${rule.id} executed successfully'
          : '✗ Rule ${rule.id} execution failed',
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: kAccent.withOpacity(0.3)),
        ),
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: AppColors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openRuleBuilder(AutomationRule? rule) async {
    final result = await Navigator.push<AutomationRule>(
      context,
      MaterialPageRoute(builder: (_) => RuleBuilderScreen(existingRule: rule)),
    );
    if (result != null) {
      _showSnack(
        rule == null
            ? 'Rule ${result.id} created'
            : 'Rule ${result.id} updated',
      );
    }
  }

  void _openSimulation(AutomationRule rule) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RuleSimulationScreen(initialRule: rule),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: GlowingFab(
        glowCtrl: _glowCtrl,
        onTap: () => _openRuleBuilder(null),
      ),
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
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.violet.withOpacity(0.05),
                      AppColors.violet.withOpacity(0.1),
                      AppColors.violet.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Consumer<AutomationProvider>(
                  builder: (_, provider, __) {
                    final rules = provider.rules;
                    final filtered = _getFiltered(rules);
                    final activeCount = rules
                        .where((r) => r.status == RuleStatus.active)
                        .length;
                    final triggeredCount = rules
                        .where((r) => r.status == RuleStatus.triggered)
                        .length;
                    final errorCount = rules
                        .where((r) => r.status == RuleStatus.error)
                        .length;
                    final totalTriggers = rules.fold(
                      0,
                      (s, r) => s + r.triggerCount,
                    );

                    return Column(
                      children: [
                        AutomationHeader(
                          total: 24,
                          active: 18,
                          errors: 3,
                          blinkT: _blinkCtrl,
                          onExecuteAll: () =>
                              context.read<AutomationProvider>().executeAll(),
                          onSettings: () {
                            // open settings
                          },
                        ),
                        RuleSummaryStrip(
                          total: filtered.length,
                          active: activeCount,
                          triggered: triggeredCount,
                          errors: errorCount,
                          totalFires: totalTriggers,
                          glowT: _glowCtrl,
                          pulseT: _pulseCtrl,
                        ),

                        RuleSearchAndFilter(
                          searchController: _searchController,
                          searchQuery: _searchQuery,
                          catFilter: _catFilter,
                          statFilter: _statFilter,
                          onSearchChanged: (val) =>
                              setState(() => _searchQuery = val),
                          onCategoryChanged: (val) =>
                              setState(() => _catFilter = val),
                          onStatusChanged: (val) =>
                              setState(() => _statFilter = val),
                        ),
                        RuleSortBar(
                          sortMode: _sortMode,
                          resultCount: filtered.length,
                          onSortChange: (mode) =>
                              setState(() => _sortMode = mode),
                        ),
                        Expanded(
                          child: RuleListView(
                            rules: filtered,
                            expandedId: _expandedId,
                            scrollController: _scrollController,
                            glowCtrl: _glowCtrl,
                            blinkCtrl: _blinkCtrl,
                            pulseCtrl: _pulseCtrl,
                            onExpandChange: (id) =>
                                setState(() => _expandedId = id),
                            onToggle: _toggleRule,
                            onDelete: (rule) =>
                                _showDeleteDialog(context, rule),
                            onDuplicate: _duplicateRule,
                            onTest: _testRule,
                            onExecute: _executeRule,
                            onEdit: _openRuleBuilder,
                            onSimulate: _openSimulation,
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

  void _showDeleteDialog(BuildContext ctx, AutomationRule rule) {
    showDialog(
      context: ctx,
      barrierColor: Colors.black87,
      builder: (_) => AlertDialog(
        backgroundColor: C.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: C.red.withOpacity(0.4)),
        ),
        title: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: C.red, size: 18),
            const SizedBox(width: 8),
            Text(
              'DELETE ${rule.id}?',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: C.red,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          '"${rule.name}" will be permanently removed.\n${rule.isSystem ? '⚠ This is a SYSTEM rule — deletion may affect city safety.' : 'This action cannot be undone.'}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: C.mutedLt,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: C.mutedLt,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              _deleteRule(rule);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: C.red.withOpacity(0.15),
                border: Border.all(color: C.red.withOpacity(0.5)),
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: C.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
