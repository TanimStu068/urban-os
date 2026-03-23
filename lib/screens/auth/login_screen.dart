import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/auth/auth_provider.dart';
import 'package:urban_os/screens/main_bottom_nav/main_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/widgets/login/bottom_bar_widget.dart';
import 'package:urban_os/widgets/login/center_glow_widget.dart';
import 'package:urban_os/widgets/login/city_silhouette.dart';
import 'package:urban_os/widgets/login/footer_section_widget.dart';
import 'package:urban_os/widgets/login/grid_overlay.dart';
import 'package:urban_os/widgets/login/corner_bracket.dart';
import 'package:urban_os/widgets/login/login_bg_painter.dart';
import 'package:urban_os/widgets/login/login_card_widget.dart';
import 'package:urban_os/widgets/login/pulse_ring.dart';
import 'package:urban_os/widgets/login/scan_beam_widget.dart';
import 'package:urban_os/widgets/login/scanline_painter.dart';
import 'package:urban_os/widgets/login/status_top_bar.dart';
import 'package:urban_os/widgets/login/top_brand_widget.dart';

// ─────────────────────────────────────────
//  LOGIN SCREEN
// ─────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Form
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _emailError, _passError;

  // Focus
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  bool _emailFocused = false;
  bool _passFocused = false;

  // Animation controllers
  late AnimationController _entranceCtrl;
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _loadingCtrl;
  late AnimationController _scanCtrl;

  // Entrance animations
  late Animation<double> _topFade, _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _field1Fade, _field2Fade, _btnFade, _footerFade;
  late Animation<Offset> _field1Slide, _field2Slide, _btnSlide;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _setupFocusListeners();
    _entranceCtrl.forward();
  }

  void _setupControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  void _setupAnimations() {
    _topFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _cardSlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    ).drive(Tween(begin: const Offset(0, 0.15), end: Offset.zero));
    _cardFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _field1Slide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));
    _field1Fade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _field2Slide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.45, 0.72, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));
    _field2Fade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.45, 0.72, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _btnSlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.58, 0.82, curve: Curves.easeOut),
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));
    _btnFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.58, 0.82, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _footerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
  }

  void _setupFocusListeners() {
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
    _passFocus.addListener(
      () => setState(() => _passFocused = _passFocus.hasFocus),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = null;
      _passError = null;
    });

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    bool valid = true;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _emailError = 'Enter a valid operator email');
      valid = false;
    }

    if (pass.length < 6) {
      setState(() => _passError = 'Password must be 6+ characters');
      valid = false;
    }

    if (!valid) return;

    setState(() => _isLoading = true);

    try {
      // 🔹 CALL PROVIDER LOGIN
      await context.read<AppAuthProvider>().login(email, pass);

      if (!mounted) return;

      // 🔹 Navigate after success
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => _emailError = 'User not found');
      }

      if (e.code == 'wrong-password') {
        setState(() => _passError = 'Wrong password');
      }

      if (e.code == 'invalid-email') {
        setState(() => _emailError = 'Invalid email');
      }
    } catch (e) {
      setState(() => _passError = 'Login failed');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _loadingCtrl.dispose();
    _scanCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Animated network bg ──
          CustomPaint(
            painter: LoginBgPainter(animation: _bgCtrl),
            size: Size.infinite,
          ),

          // ── Grid overlay ──
          Positioned.fill(child: GridOverlay(animation: _glowCtrl)),

          // ── Scanlines ──
          Positioned.fill(child: CustomPaint(painter: ScanlinePainter())),

          // ── Scan beam (moving horizontal light) ──
          ScanBeam(animation: _scanCtrl, height: size.height),

          // ── Left city silhouette ──
          Positioned(
            left: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _topFade,
              child: CustomPaint(
                painter: CitySilhouettePainter(side: 'left'),
                size: Size(size.width * 0.28, size.height * 0.55),
              ),
            ),
          ),

          // ── Right city silhouette ──
          Positioned(
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _topFade,
              child: CustomPaint(
                painter: CitySilhouettePainter(side: 'right'),
                size: Size(size.width * 0.28, size.height * 0.55),
              ),
            ),
          ),

          // ── Center radial glow ──
          CenterGlow(animation: _glowCtrl),

          // ── Pulse rings ──
          PulseRings(animation: _pulseCtrl),

          // ── Corner brackets ──
          ..._corners(),

          // ── Main scrollable content ──
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.06),

                      // ── Top brand section ──
                      FadeTransition(opacity: _topFade, child: TopBrand()),

                      SizedBox(height: size.height * 0.05),

                      // ── Login card ──
                      FadeTransition(
                        opacity: _cardFade,
                        child: SlideTransition(
                          position: _cardSlide,
                          child: LoginCard(
                            emailCtrl: _emailCtrl,
                            passCtrl: _passCtrl,
                            formKey: _formKey,
                            emailFocus: _emailFocus,
                            passFocus: _passFocus,
                            emailFocused: _emailFocused,
                            passFocused: _passFocused,
                            obscurePass: _obscurePass,
                            rememberMe: _rememberMe,
                            isLoading: _isLoading,
                            emailError: _emailError,
                            passError: _passError,
                            loadingCtrl: _loadingCtrl,
                            field1Fade: _field1Fade,
                            field1Slide: _field1Slide,
                            field2Fade: _field2Fade,
                            field2Slide: _field2Slide,
                            btnFade: _btnFade,
                            btnSlide: _btnSlide,
                            onTogglePass: () =>
                                setState(() => _obscurePass = !_obscurePass),
                            onToggleRemember: () =>
                                setState(() => _rememberMe = !_rememberMe),
                            onLogin: _handleLogin,
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // ── Footer ──
                      FadeTransition(
                        opacity: _footerFade,
                        child: const FooterSection(),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Status dots top ──
          FadeTransition(opacity: _topFade, child: const StatusTopBar()),

          // ── Bottom bar ──
          FadeTransition(opacity: _footerFade, child: const BottomBar()),
        ],
      ),
    );
  }

  List<Widget> _corners() => [
    Positioned(
      top: 20,
      left: 20,
      child: CornerBracket(flipX: false, flipY: false),
    ),
    Positioned(
      top: 20,
      right: 20,
      child: CornerBracket(flipX: true, flipY: false),
    ),
    Positioned(
      bottom: 20,
      left: 20,
      child: CornerBracket(flipX: false, flipY: true),
    ),
    Positioned(
      bottom: 20,
      right: 20,
      child: CornerBracket(flipX: true, flipY: true),
    ),
  ];
}
