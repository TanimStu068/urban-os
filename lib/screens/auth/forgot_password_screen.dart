import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/providers/auth/auth_provider.dart';
import 'package:urban_os/widgets/city/bg_painter.dart';
import 'package:urban_os/widgets/forget_password/auth_card_swicther.dart';
import 'package:urban_os/widgets/forget_password/bottom_bar.dart';
import 'package:urban_os/widgets/forget_password/cb_widget.dart';
import 'package:urban_os/widgets/forget_password/center_glow_widget.dart';
import 'package:urban_os/widgets/forget_password/footer_widget.dart';
import 'package:urban_os/widgets/forget_password/grid_overlay_widget.dart';
import 'package:urban_os/widgets/forget_password/hex_grid_painter.dart';
import 'package:urban_os/widgets/forget_password/phase_tracker_widget.dart';
import 'package:urban_os/widgets/forget_password/pulse_ring_widget.dart';
import 'package:urban_os/widgets/forget_password/radar_rings_widget.dart';
import 'package:urban_os/widgets/forget_password/scan_beam_widget.dart';
import 'package:urban_os/widgets/forget_password/scan_line_painter_widget.dart';
import 'package:urban_os/widgets/forget_password/status_bar_widget.dart';
import 'package:urban_os/widgets/forget_password/top_band_widget.dart';

// ─────────────────────────────────────────
//  PHASES
// ─────────────────────────────────────────
enum Phase { email, otp, reset, done }

// ─────────────────────────────────────────
//  FORGOT PASSWORD SCREEN
// ─────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  Phase _phase = Phase.email;

  // Controllers
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());

  // Focus
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _emailFocused = false, _passFocused = false, _confirmFocused = false;

  // State
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  double _passStrength = 0;
  int _resendCountdown = 30;
  bool _canResend = false;
  String? _emailError, _passError, _confirmError, _otpError;

  // Stores the verified OOB code across phases
  String _verifiedOtpCode = '';

  // Animation controllers
  late AnimationController _entranceCtrl;
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _loadingCtrl;
  late AnimationController _phaseCtrl;
  late AnimationController _successCtrl;
  late AnimationController _lockCtrl;
  late AnimationController _radarCtrl;
  late AnimationController _timerCtrl;

  // Entrance
  late Animation<double> _topFade, _cardFade, _footerFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _setupFocusListeners();
    _entranceCtrl.forward();
    _passCtrl.addListener(_calcStrength);
  }

  void _setupControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
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
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _phaseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _lockCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _timerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
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
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
    _passFocus.addListener(
      () => setState(() => _passFocused = _passFocus.hasFocus),
    );
    _confirmFocus.addListener(
      () => setState(() => _confirmFocused = _confirmFocus.hasFocus),
    );
  }

  void _calcStrength() {
    final p = _passCtrl.text;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9]'))) s += 0.25;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s += 0.25;
    setState(() => _passStrength = s);
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  FIREBASE PHASE LOGIC
  // ══════════════════════════════════════════════════════════════════════════

  /// Phase 0 — Validate email locally, then send Firebase reset email.
  Future<void> _submitEmail() async {
    final email = _emailCtrl.text.trim();

    // Basic format check
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _emailError = 'Enter a valid operator email');
      return;
    }

    setState(() {
      _emailError = null;
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      final exists = await authProvider.isEmailRegistered(email);
      if (!exists) {
        setState(() {
          _emailError = 'No operator account found for this email';
          _isLoading = false;
        });
        return;
      }

      // Send the actual Firebase reset email
      await authProvider.sendPasswordResetEmail(email);

      if (!mounted) return;
      setState(() => _isLoading = false);
      _goToPhase(Phase.otp);
      _startResendTimer();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _emailError = _mapFirebaseError(e);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _emailError = 'Unexpected error. Please try again.';
      });
    }
  }

  Future<void> _submitOtp() async {
    final otp = _otpCtrls.map((c) => c.text).join();
    if (otp.length < 6) {
      setState(() => _otpError = 'Enter the complete 6-character code');
      return;
    }

    setState(() {
      _otpError = null;
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      // Verify the OOB code with Firebase — throws if expired / invalid
      await authProvider.verifyPasswordResetCode(otp);

      // Store for use in the reset phase
      _verifiedOtpCode = otp;

      if (!mounted) return;
      setState(() => _isLoading = false);
      _goToPhase(Phase.reset);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _otpError = _mapFirebaseError(e);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _otpError = 'Invalid or expired code. Please try again.';
      });
    }
  }

  /// Phase 2 — Validates passwords then calls Firebase confirmPasswordReset.
  Future<void> _submitReset() async {
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

    if (!ok) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      await authProvider.confirmPasswordReset(
        otp: _verifiedOtpCode,
        newPassword: _passCtrl.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      _goToPhase(Phase.done);
      _successCtrl.forward();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        // Surface error in confirm field so it's visible
        _confirmError = _mapFirebaseError(e);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _confirmError = 'Reset failed. Please restart the process.';
      });
    }
  }

  // ─────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────

  /// Maps common FirebaseAuthException codes to user-friendly messages.
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'expired-action-code':
        return 'Reset code expired. Please request a new one';
      case 'invalid-action-code':
        return 'Invalid reset code. Check and try again';
      case 'weak-password':
        return 'Password is too weak. Use 8+ chars with mixed types';
      case 'operation-not-allowed':
        return 'Password reset is not enabled for this project';
      default:
        return e.message ?? 'An error occurred (${e.code})';
    }
  }

  void _goToPhase(Phase p) {
    _phaseCtrl.forward(from: 0).then((_) {
      setState(() => _phase = p);
      _phaseCtrl.reverse();
    });
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) _canResend = true;
      });
      return _resendCountdown > 0;
    });
  }

  /// Resend: fires another Firebase reset email and clears OTP boxes.
  void _resendOtp() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      await authProvider.sendPasswordResetEmail(_emailCtrl.text.trim());
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _mapFirebaseError(e),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    _startResendTimer();
    for (final c in _otpCtrls) c.clear();
    _otpFocus[0].requestFocus();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _loadingCtrl.dispose();
    _phaseCtrl.dispose();
    _successCtrl.dispose();
    _lockCtrl.dispose();
    _radarCtrl.dispose();
    _timerCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  //  BUILD  (UI unchanged from original)
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Bg
          CustomPaint(
            painter: BgPainter(anim: _bgCtrl),
            size: Size.infinite,
          ),
          Positioned.fill(child: GridOverlay(anim: _glowCtrl)),
          Positioned.fill(child: CustomPaint(painter: ScanLinePainterWidget())),
          ScanBeam(anim: _scanCtrl, h: size.height),

          // Radar rings
          RadarRings(anim: _radarCtrl),

          // Hex grid accent (top right)
          Positioned(
            top: 0,
            right: 0,
            child: FadeTransition(
              opacity: _topFade,
              child: CustomPaint(
                painter: HexGridPainter(),
                size: const Size(200, 200),
              ),
            ),
          ),

          // Hex grid accent (bottom left)
          Positioned(
            bottom: 0,
            left: 0,
            child: FadeTransition(
              opacity: _topFade,
              child: CustomPaint(
                painter: HexGridPainter(),
                size: const Size(180, 180),
              ),
            ),
          ),

          // Center glow
          CenterGlow(anim: _glowCtrl),

          // Pulse rings
          PulseRings(anim: _pulseCtrl),

          // Corners
          ..._corners(),

          // Main
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.055),
                    FadeTransition(opacity: _topFade, child: TopBrand()),
                    const SizedBox(height: 22),
                    FadeTransition(
                      opacity: _topFade,
                      child: PhaseTracker(phase: _phase),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: AnimatedBuilder(
                          animation: _phaseCtrl,
                          builder: (_, child) => Opacity(
                            opacity: (1.0 - _phaseCtrl.value).clamp(0.0, 1.0),
                            child: Transform.translate(
                              offset: Offset(0, _phaseCtrl.value * 20),
                              child: child,
                            ),
                          ),
                          child: AuthCardSwitcher(
                            phase: _phase,
                            emailCtrl: _emailCtrl,
                            emailFocus: _emailFocus,
                            emailFocused: _emailFocused,
                            emailError: _emailError,
                            otpCtrls: _otpCtrls,
                            otpFocus: _otpFocus,
                            otpError: _otpError,
                            passCtrl: _passCtrl,
                            passFocus: _passFocus,
                            passFocused: _passFocused,
                            confirmCtrl: _confirmCtrl,
                            confirmFocus: _confirmFocus,
                            confirmFocused: _confirmFocused,
                            obscurePass: _obscurePass,
                            obscureConfirm: _obscureConfirm,
                            passStrength: _passStrength,
                            passError: _passError,
                            confirmError: _confirmError,
                            isLoading: _isLoading,
                            loadingCtrl: _loadingCtrl,
                            lockCtrl: _lockCtrl,
                            radarCtrl: _radarCtrl,
                            timerCtrl: _timerCtrl,
                            successCtrl: _successCtrl,
                            canResend: _canResend,
                            countdown: _resendCountdown,
                            onSubmitEmail: _submitEmail,
                            onSubmitOtp: _submitOtp,
                            onResendOtp: _resendOtp,
                            onSubmitReset: _submitReset,
                            onTogglePass: () =>
                                setState(() => _obscurePass = !_obscurePass),
                            onToggleConfirm: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_phase != Phase.done)
                      FadeTransition(
                        opacity: _footerFade,
                        child: const Footer(),
                      ),
                    const SizedBox(height: 40),
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
    Positioned(top: 20, left: 20, child: CB(fx: false, fy: false)),
    Positioned(top: 20, right: 20, child: CB(fx: true, fy: false)),
    Positioned(bottom: 20, left: 20, child: CB(fx: false, fy: true)),
    Positioned(bottom: 20, right: 20, child: CB(fx: true, fy: true)),
  ];
}
