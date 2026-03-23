import 'dart:math';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_setting_data_model.dart';
import 'package:urban_os/widgets/system_setting/account_section.dart';
import 'package:urban_os/widgets/system_setting/data_section.dart';
import 'package:urban_os/widgets/system_setting/display_section.dart';
import 'package:urban_os/widgets/system_setting/info_section.dart';
import 'package:urban_os/widgets/system_setting/legal_section.dart';
import 'package:urban_os/widgets/system_setting/performance_section.dart';
import 'package:urban_os/widgets/system_setting/sound_section.dart';
import 'package:urban_os/widgets/system_setting/storage_section.dart';
import 'package:urban_os/widgets/system_setting/system_header.dart';
import 'package:urban_os/widgets/system_setting/system_section.dart';

//  COLOR PALETTE (UrbanOS — System Settings)
typedef C = AppColors;

const kAccent = C.cyan;

// ─────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────
class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen>
    with TickerProviderStateMixin {
  // ── data ──
  late SystemSettings _settings;
  late StorageInfo _storage;
  late CacheInfo _cache;

  // ── animation controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _sliderCtrl;
  late AnimationController _entranceCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _settings = SystemSettings();
    _storage = buildStorageInfo();
    _cache = buildCacheInfo();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _initAnims() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 38),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _sliderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _sliderCtrl.dispose();
    _entranceCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Navigation helpers ──
  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // Background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.4, -0.3),
                  radius: 1.2,
                  colors: [C.cyan.withOpacity(0.05), C.bg],
                ),
              ),
            ),
          ),
          // Scan beam
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
                      C.cyan.withOpacity(0.04),
                      C.cyan.withOpacity(0.12),
                      C.cyan.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    SystemHeader(
                      glowAnimation: _glowCtrl,
                      onBackTap: () {
                        // Optional custom back logic
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollCtrl,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
                        child: Column(
                          children: [
                            DisplaySection(
                              darkMode: _settings.darkMode,
                              onDarkModeChanged: (val) =>
                                  setState(() => _settings.darkMode = val),
                              brightnessLevel: _settings.brightnessLevel,
                              onBrightnessChanged: (val) => setState(
                                () => _settings.brightnessLevel = val,
                              ),
                              animationsEnabled: _settings.animationsEnabled,
                              onAnimationsChanged: (val) => setState(
                                () => _settings.animationsEnabled = val,
                              ),
                              sliderCtrl: _sliderCtrl,
                            ),
                            const SizedBox(height: 12),
                            SoundSection(
                              soundsEnabled: _settings.soundsEnabled,
                              onSoundsChanged: (val) =>
                                  setState(() => _settings.soundsEnabled = val),
                              volumeLevel: _settings.volumeLevel,
                              onVolumeChanged: (val) =>
                                  setState(() => _settings.volumeLevel = val),
                              hapticFeedbackEnabled:
                                  _settings.hapticFeedbackEnabled,
                              onHapticChanged: (val) => setState(
                                () => _settings.hapticFeedbackEnabled = val,
                              ),
                              sliderCtrl: _sliderCtrl,
                            ),
                            const SizedBox(height: 12),
                            PerformanceSection(
                              lowPowerMode: _settings.lowPowerMode,
                              onLowPowerModeChanged: (val) =>
                                  setState(() => _settings.lowPowerMode = val),
                              updateFrequency: _settings.updateFrequency,
                              onFrequencyChanged: (freq) => setState(
                                () => _settings.updateFrequency = freq,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DataSection(
                              locationServicesEnabled:
                                  _settings.locationServicesEnabled,
                              onLocationChanged: (val) => setState(
                                () => _settings.locationServicesEnabled = val,
                              ),
                              dataCollectionEnabled:
                                  _settings.dataCollectionEnabled,
                              onDataCollectionChanged: (val) => setState(
                                () => _settings.dataCollectionEnabled = val,
                              ),
                            ),
                            const SizedBox(height: 12),
                            StorageSection(
                              used: _storage.used,
                              total: _storage.total,
                              percent: _storage.usagePercent,
                              cacheSize: _cache.size,
                              cacheItemCount: _cache.itemCount,
                              onClearCache: () {
                                // Handle cache clearing
                              },
                            ),
                            const SizedBox(height: 12),
                            SystemSection(
                              automaticUpdatesEnabled:
                                  _settings.automaticUpdatesEnabled,
                              onAutomaticUpdatesChanged: (val) {
                                setState(
                                  () => _settings.automaticUpdatesEnabled = val,
                                );
                              },
                              onAppVersionTap: () {
                                // Handle app version info tap
                              },
                            ),
                            const SizedBox(height: 12),

                            // ── NEW NAVIGATION SECTIONS ──
                            AccountSection(navigateTo: _navigateTo),
                            const SizedBox(height: 12),
                            InfoSection(navigateTo: _navigateTo),
                            const SizedBox(height: 12),
                            LegalSection(navigateTo: _navigateTo),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
