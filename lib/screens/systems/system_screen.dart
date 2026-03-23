import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/animated_bg.dart';
import 'package:urban_os/widgets/system/grid_paint.dart';
import 'package:urban_os/widgets/system/top_bar.dart';
import 'package:urban_os/widgets/system/scan_line.dart';
import 'package:urban_os/widgets/system/ben_to_grid.dart';
import 'package:urban_os/widgets/system/section_filter.dart';
import 'package:urban_os/widgets/system/system_stat.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS
// ═════════════════════════════════════════════════════════════════════════════
typedef C = AppColors;
typedef _C = AppColors;

// ═════════════════════════════════════════════════════════════════════════════
//  SYSTEM SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _hotCtrl;
  late final AnimationController _scanCtrl;
  late final AnimationController _orbitCtrl;

  int _selectedSection = 0;

  late final List<Section> _sections;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _hotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _sections = buildSections();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    _hotCtrl.dispose();
    _scanCtrl.dispose();
    _orbitCtrl.dispose();
    super.dispose();
  }

  void _navigate(BuildContext ctx, Widget Function() builder) {
    HapticFeedback.lightImpact();
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => builder()));
  }

  List<MapEntry<Section, SystemEntry>> get _visibleEntries {
    final result = <MapEntry<Section, SystemEntry>>[];
    for (final sec in _sections) {
      if (_selectedSection == 0 ||
          _sections.indexOf(sec) + 1 == _selectedSection) {
        for (final e in sec.entries) {
          result.add(MapEntry(sec, e));
        }
      }
    }
    return result;
  }

  int get _totalModules => _sections.fold(0, (a, s) => a + s.entries.length);
  int get _hotCount =>
      _sections.expand((s) => s.entries).where((e) => e.isHot).length;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _C.bg,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: AnimatedBg(ctrl: _bgCtrl)),
            Positioned.fill(child: const GridPaint()),
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TopBar(
                      onBack: () => Navigator.maybePop(context),
                      totalModules: _totalModules,
                      hotCount: _hotCount,
                      hotCtrl: _hotCtrl,
                      orbitCtrl: _orbitCtrl,
                    ),
                    SystemStats(sections: _sections, hotCtrl: _hotCtrl),
                    SectionFilter(
                      sections: _sections,
                      selected: _selectedSection,
                      onSelect: (i) => setState(() => _selectedSection = i),
                    ),
                    Expanded(
                      child: BentoGrid(
                        entries: _visibleEntries,
                        entryCtrl: _entryCtrl,
                        hotCtrl: _hotCtrl,
                        onTap: (e) => _navigate(context, e.builder),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ScanLine(ctrl: _scanCtrl),
          ],
        ),
      ),
    );
  }
}
