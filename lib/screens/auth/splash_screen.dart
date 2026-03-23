import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/splash_screen_data_model.dart';
import 'package:urban_os/screens/auth/login_screen.dart';
import 'package:urban_os/screens/main_bottom_nav/main_scaffold.dart';
import 'package:urban_os/screens/settings/onboarding_screens.dart';
import 'package:urban_os/widgets/splash/bottom_bar.dart';
import 'package:urban_os/widgets/splash/brand_text.dart';
import 'package:urban_os/widgets/splash/center_glow.dart';
import 'package:urban_os/widgets/splash/grid_overlay.dart';
import 'package:urban_os/widgets/splash/loader_widget.dart';
import 'package:urban_os/widgets/splash/logo_ring.dart';
import 'package:urban_os/widgets/splash/network_painter.dart';
import 'package:urban_os/widgets/splash/pulse_ring.dart';
import 'package:urban_os/widgets/splash/scan_line_overlay.dart';
import 'package:urban_os/widgets/splash/side_decoration.dart';
import 'package:urban_os/widgets/splash/stat_row.dart';
import 'package:urban_os/widgets/splash/status_bar.dart';
import 'package:urban_os/widgets/splash/hex_accents.dart';
import 'package:urban_os/widgets/splash/corner_bracket.dart';

// ─────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _masterCtrl; // overall entrance
  late AnimationController _ringCtrl; // logo ring rotation
  late AnimationController _ringRevCtrl; // inner ring (reverse)
  late AnimationController _glowCtrl; // center glow breath
  late AnimationController _pulseCtrl; // expanding pulse rings
  late AnimationController _loadCtrl; // progress bar
  late AnimationController _particleCtrl; // particles

  // Entrance animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _brandSlide;
  late Animation<double> _brandOpacity;
  late Animation<double> _dividerOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _statsOpacity;
  late Animation<Offset> _statsSlide;
  late Animation<double> _loaderOpacity;
  late Animation<double> _bottomOpacity;
  late Animation<double> _sideOpacity;
  late Animation<double> _statusOpacity;

  // Boot sequence
  int _bootStep = 0;
  double _loadPct = 0;
  String _bootLabel = 'INITIALIZING SYSTEMS...';
  String _bootMessage = 'Connecting to city network...';

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _startSequence();
  }

  void _setupControllers() {
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _ringRevCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _loadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _setupAnimations() {
    // Logo
    _logoScale = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.08, 0.32, curve: Curves.elasticOut),
    ).drive(Tween(begin: 0.3, end: 1.0));
    _logoOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.08, 0.28, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    // Brand
    _brandSlide = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.28, 0.52, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));
    _brandOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.28, 0.52, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _dividerOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.40, 0.58, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _taglineOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.46, 0.62, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    // Stats
    _statsSlide = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.52, 0.72, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));
    _statsOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.52, 0.72, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    // Loader
    _loaderOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.60, 0.80, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    // Bottom / sides / status
    _bottomOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _sideOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.50, 0.70, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _statusOpacity = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _masterCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 2200));
    _loadCtrl.forward();
    _runBootSequence();
  }

  void _runBootSequence() async {
    for (int i = 0; i < bootMessages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 370));

      if (!mounted) return;

      setState(() {
        _bootStep = i + 1;
        _bootMessage = bootMessages[i];
        _loadPct = (i + 1) / bootMessages.length;

        if (i == bootMessages.length - 1) {
          _bootLabel = 'SYSTEM READY';
        }
      });

      if (i == bootMessages.length - 1) {
        final prefs = await SharedPreferences.getInstance();
        final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

        final user = FirebaseAuth.instance.currentUser;

        if (!mounted) return;

        if (!seenOnboarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        } else if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScaffold()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _ringCtrl.dispose();
    _ringRevCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _loadCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final spacingSmall = isSmallScreen ? 16.0 : 40.0;
    final spacingMed = isSmallScreen ? 28.0 : 56.0;
    final spacingLarge = isSmallScreen ? 32.0 : 64.0;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // ── Network canvas background ──
          CustomPaint(
            painter: NetworkPainter(animation: _particleCtrl),
            size: Size.infinite,
          ),

          // ── Grid overlay ──
          Positioned.fill(child: GridOverlay(animation: _glowCtrl)),

          // ── Scanlines ──
          Positioned.fill(child: ScanlineOverlay()),

          // ── Center glow ──
          CenterGlow(animation: _glowCtrl),

          // ── Pulse rings ──
          PulseRings(animation: _pulseCtrl),

          // ── Corner brackets ──
          ..._buildCorners(),

          // ── Side decorations ──
          FadeTransition(opacity: _sideOpacity, child: SideDecorations()),

          // ── Status bar ──
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: FadeTransition(opacity: _statusOpacity, child: StatusBar()),
          ),

          // ── MAIN CENTER CONTENT ──
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo ring
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: LogoRing(
                          ringCtrl: _ringCtrl,
                          ringRevCtrl: _ringRevCtrl,
                          glowCtrl: _glowCtrl,
                          isSmallScreen: isSmallScreen,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingSmall),

                    // Brand text
                    FadeTransition(
                      opacity: _brandOpacity,
                      child: SlideTransition(
                        position: _brandSlide,
                        child: BrandText(
                          dividerOpacity: _dividerOpacity,
                          taglineOpacity: _taglineOpacity,
                          isSmallScreen: isSmallScreen,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingMed),

                    // Stats row
                    FadeTransition(
                      opacity: _statsOpacity,
                      child: SlideTransition(
                        position: _statsSlide,
                        child: StatsRow(isSmallScreen: isSmallScreen),
                      ),
                    ),

                    SizedBox(height: spacingLarge),

                    // Loader
                    FadeTransition(
                      opacity: _loaderOpacity,
                      child: LoaderWidget(
                        pct: _loadPct,
                        label: _bootLabel,
                        message: _bootMessage,
                        step: _bootStep,
                        total: bootMessages.length,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom bar ──
          FadeTransition(opacity: _bottomOpacity, child: const BottomBar()),

          // ── Hex accents ──
          FadeTransition(opacity: _sideOpacity, child: const HexAccents()),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() => [
    Positioned(
      top: 24,
      left: 24,
      child: CornerBracket(flip: false, flipY: false, delay: 500),
    ),
    Positioned(
      top: 24,
      right: 24,
      child: CornerBracket(flip: true, flipY: false, delay: 700),
    ),
    Positioned(
      bottom: 24,
      left: 24,
      child: CornerBracket(flip: false, flipY: true, delay: 900),
    ),
    Positioned(
      bottom: 24,
      right: 24,
      child: CornerBracket(flip: true, flipY: true, delay: 1100),
    ),
  ];
}
