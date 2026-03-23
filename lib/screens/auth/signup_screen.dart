import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_os/widgets/signup/bg_painter.dart';
import 'package:urban_os/widgets/signup/bottom_bar.dart';
import 'package:urban_os/widgets/signup/cb_conner.dart';
import 'package:urban_os/widgets/signup/center_glow.dart';
import 'package:urban_os/widgets/signup/dialognal_painter.dart';
import 'package:urban_os/widgets/signup/footer.dart';
import 'package:urban_os/widgets/signup/grid_overlay.dart';
import 'package:urban_os/widgets/signup/pulse_rings.dart';
import 'package:urban_os/widgets/signup/scam_beam.dart';
import 'package:urban_os/widgets/signup/scan_line_painter.dart';
import 'package:urban_os/widgets/signup/signup_card.dart';
import 'package:urban_os/widgets/signup/status_bar.dart';
import 'package:urban_os/widgets/signup/step_indicator.dart';
import 'package:urban_os/widgets/signup/success_view.dart';
import 'package:urban_os/widgets/signup/top_brand.dart';

// ─────────────────────────────────────────
//  SIGNUP SCREEN — 3-STEP WIZARD
// ─────────────────────────────────────────
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  // Wizard state
  int _step = 0; // 0=identity, 1=role, 2=security
  final _pageCtrl = PageController();

  // Form controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // Focus nodes
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _idFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _nameFocused = false,
      _emailFocused = false,
      _idFocused = false,
      _passFocused = false,
      _confirmFocused = false;

  // Selection state
  int _selectedRole = -1;
  bool _obscurePass = true, _obscureConfirm = true;
  bool _agreeTerms = false, _agreeData = false;
  bool _isLoading = false;
  double _passStrength = 0;

  // Error state
  String? _nameError, _emailError, _idError, _passError, _confirmError;

  // Animation controllers
  late AnimationController _entranceCtrl;
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _stepCtrl;
  late AnimationController _loadingCtrl;
  late AnimationController _successCtrl;

  // Animations
  late Animation<double> _topFade, _cardFade, _footerFade;
  late Animation<Offset> _cardSlide;

  bool _registrationComplete = false;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _setupFocusListeners();
    _entranceCtrl.forward();
    _passCtrl.addListener(_calcPassStrength);
  }

  void _setupControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _stepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  void _setupAnimations() {
    _topFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _cardSlide = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ).drive(Tween(begin: const Offset(0, 0.12), end: Offset.zero));
    _cardFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _footerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
  }

  void _setupFocusListeners() {
    _nameFocus.addListener(
      () => setState(() => _nameFocused = _nameFocus.hasFocus),
    );
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
    _idFocus.addListener(() => setState(() => _idFocused = _idFocus.hasFocus));
    _passFocus.addListener(
      () => setState(() => _passFocused = _passFocus.hasFocus),
    );
    _confirmFocus.addListener(
      () => setState(() => _confirmFocused = _confirmFocus.hasFocus),
    );
  }

  void _calcPassStrength() {
    final p = _passCtrl.text;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9]'))) s += 0.25;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s += 0.25;
    setState(() => _passStrength = s);
  }

  void _nextStep() {
    if (_step == 0) {
      bool ok = true;
      if (_nameCtrl.text.trim().length < 2) {
        setState(() => _nameError = 'Enter your full name');
        ok = false;
      } else {
        setState(() => _nameError = null);
      }
      if (!_emailCtrl.text.contains('@')) {
        setState(() => _emailError = 'Enter a valid email');
        ok = false;
      } else {
        setState(() => _emailError = null);
      }
      if (_idCtrl.text.trim().length < 3) {
        setState(() => _idError = 'Enter a valid operator ID');
        ok = false;
      } else {
        setState(() => _idError = null);
      }
      if (!ok) return;
    }
    if (_step == 1 && _selectedRole == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.bgCard,
          content: const Text(
            'Select an operator role to continue',
            style: TextStyle(
              fontFamily: 'monospace',
              color: AppColors.amber,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.amber, width: 1),
          ),
        ),
      );
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _handleRegister() async {
    bool ok = true;

    if (_passCtrl.text.length < 8) {
      setState(() => _passError = 'Min 8 characters required');
      ok = false;
    } else {
      setState(() => _passError = null);
    }

    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() => _confirmError = 'Passwords do not match');
      ok = false;
    } else {
      setState(() => _confirmError = null);
    }

    if (!_agreeTerms) {
      ok = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the terms')),
      );
    }

    if (!ok) return;

    setState(() => _isLoading = true);

    try {
      // 🔹 Call Provider register
      await context.read<AppAuthProvider>().register(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      if (!mounted) return;

      setState(() {
        _registrationComplete = true;
      });

      _successCtrl.forward();
    }
    // 🔴 Firebase specific errors
    on FirebaseAuthException catch (e) {
      String message = "Registration failed";

      if (e.code == 'email-already-in-use') {
        message = "This email is already registered";
      }

      if (e.code == 'invalid-email') {
        message = "Invalid email format";
      }

      if (e.code == 'weak-password') {
        message = "Password is too weak";
      }

      if (e.code == 'operation-not-allowed') {
        message = "Email/password accounts are disabled";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred")),
      );
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
    _scanCtrl.dispose();
    _stepCtrl.dispose();
    _loadingCtrl.dispose();
    _successCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _idCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _idFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
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
          // Bg network
          CustomPaint(
            painter: BgPainter(animation: _bgCtrl),
            size: Size.infinite,
          ),

          // Grid
          Positioned.fill(child: GridOverlay(anim: _glowCtrl)),

          // Scanlines
          Positioned.fill(child: CustomPaint(painter: ScanlinePainter())),

          // Scan beam
          ScanBeam(anim: _scanCtrl, height: size.height),

          // Diagonal accent lines
          Positioned.fill(
            child: FadeTransition(
              opacity: _topFade,
              child: CustomPaint(painter: DiagonalPainter()),
            ),
          ),

          // Glow
          CenterGlow(anim: _glowCtrl),

          // Pulse rings
          PulseRings(anim: _pulseCtrl),

          // Corner brackets
          ..._corners(),

          // Main content
          SafeArea(
            child: _registrationComplete
                ? SuccessView(anim: _successCtrl)
                : SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.05),

                          // Top brand
                          FadeTransition(opacity: _topFade, child: TopBrand()),

                          const SizedBox(height: 24),

                          // Step indicator
                          FadeTransition(
                            opacity: _topFade,
                            child: StepIndicator(step: _step),
                          ),

                          const SizedBox(height: 20),

                          // Card
                          FadeTransition(
                            opacity: _cardFade,
                            child: SlideTransition(
                              position: _cardSlide,
                              child: SignupCard(
                                pageCtrl: _pageCtrl,
                                step: _step,
                                // step 0
                                nameCtrl: _nameCtrl,
                                nameFocus: _nameFocus,
                                nameFocused: _nameFocused,
                                nameError: _nameError,
                                emailCtrl: _emailCtrl,
                                emailFocus: _emailFocus,
                                emailFocused: _emailFocused,
                                emailError: _emailError,
                                idCtrl: _idCtrl,
                                idFocus: _idFocus,
                                idFocused: _idFocused,
                                idError: _idError,
                                // step 1
                                selectedRole: _selectedRole,
                                onRoleSelect: (i) =>
                                    setState(() => _selectedRole = i),
                                // step 2
                                passCtrl: _passCtrl,
                                passFocus: _passFocus,
                                passFocused: _passFocused,
                                passError: _passError,
                                confirmCtrl: _confirmCtrl,
                                confirmFocus: _confirmFocus,
                                confirmFocused: _confirmFocused,
                                confirmError: _confirmError,
                                obscurePass: _obscurePass,
                                obscureConfirm: _obscureConfirm,
                                passStrength: _passStrength,
                                agreeTerms: _agreeTerms,
                                agreeData: _agreeData,
                                isLoading: _isLoading,
                                loadingCtrl: _loadingCtrl,
                                onTogglePass: () => setState(
                                  () => _obscurePass = !_obscurePass,
                                ),
                                onToggleConfirm: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                onToggleTerms: () =>
                                    setState(() => _agreeTerms = !_agreeTerms),
                                onToggleData: () =>
                                    setState(() => _agreeData = !_agreeData),
                                onNext: _nextStep,
                                onBack: _prevStep,
                                onRegister: _handleRegister,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          FadeTransition(
                            opacity: _footerFade,
                            child: const Footer(),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
          ),

          // Status bar
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: FadeTransition(opacity: _topFade, child: const StatusBar()),
          ),

          // Bottom bar
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _footerFade,
              child: const BottomBar(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _corners() => [
    Positioned(top: 20, left: 20, child: CornerBracket(fx: false, fy: false)),
    Positioned(top: 20, right: 20, child: CornerBracket(fx: true, fy: false)),
    Positioned(bottom: 20, left: 20, child: CornerBracket(fx: false, fy: true)),
    Positioned(bottom: 20, right: 20, child: CornerBracket(fx: true, fy: true)),
  ];
}
