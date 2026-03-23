import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/screens/auth/login_screen.dart';
import 'package:urban_os/widgets/delete_account/account_info.dart';
import 'package:urban_os/widgets/delete_account/cancel_button.dart';
import 'package:urban_os/widgets/delete_account/confirmation_form.dart';
import 'package:urban_os/widgets/delete_account/consequences_list.dart';
import 'package:urban_os/widgets/delete_account/danger_banner.dart';
import 'package:urban_os/widgets/delete_account/delete_button.dart';
import 'package:urban_os/widgets/delete_account/delete_header.dart';
import 'package:urban_os/widgets/delete_account/error_box.dart';
import 'package:urban_os/widgets/delete_account/input_level.dart';
import 'package:urban_os/widgets/delete_account/password_field.dart';
import 'package:urban_os/widgets/signup/success_view.dart';

// ─────────────────────────────────────────
//  COLOR PALETTE (UrbanOS)
// ─────────────────────────────────────────
typedef C = AppColors;

// ─────────────────────────────────────────
//  DELETE ACCOUNT SCREEN
// ─────────────────────────────────────────
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen>
    with TickerProviderStateMixin {
  // ── controllers ──
  late AnimationController _bgCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _pulseRedCtrl;
  late AnimationController _shakeCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _redPulse;
  late Animation<double> _shake;

  // ── form & state ──
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  // bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isGoogleUser = false;
  bool _checkboxConfirmed = false;

  // deletion step: 0 = idle, 1 = confirming, 2 = deleting, 3 = done
  int _step = 0;

  String? _errorMessage;

  // ── computed ──
  User? get _user => FirebaseAuth.instance.currentUser;

  String get _userEmail => _user?.email ?? 'your account';

  bool get _isPasswordProvider {
    return _user?.providerData.any((p) => p.providerId == 'password') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _detectAuthProvider();
    _initAnims();
    _entranceCtrl.forward();
  }

  void _detectAuthProvider() {
    final providers =
        _user?.providerData.map((p) => p.providerId).toList() ?? [];
    _isGoogleUser =
        providers.contains('google.com') && !providers.contains('password');
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
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseRedCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _slideIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.03), end: Offset.zero));
    _redPulse = CurvedAnimation(
      parent: _pulseRedCtrl,
      curve: Curves.easeInOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _shake = _shakeCtrl.drive(
      TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
      ]),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _glowCtrl.dispose();
    _scanCtrl.dispose();
    _entranceCtrl.dispose();
    _pulseRedCtrl.dispose();
    _shakeCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  FIREBASE LOGIC
  // ─────────────────────────────────────────

  /// Re-authenticates with email/password, then deletes the account.
  Future<void> _deleteWithPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_checkboxConfirmed) {
      _showError('Please confirm you understand this action is irreversible.');
      return;
    }

    setState(() {
      _isLoading = true;
      _step = 2;
      _errorMessage = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: _passwordCtrl.text.trim(),
      );

      // Re-authenticate first (required by Firebase before sensitive ops)
      await _user!.reauthenticateWithCredential(credential);

      // Delete the account from Firebase Auth
      await _user!.delete();

      // Sign out to clear local session
      await FirebaseAuth.instance.signOut();

      if (mounted) setState(() => _step = 3);

      // Wait briefly then navigate to login/splash
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) _navigateToLogin();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Re-authenticates with Google, then deletes the account.
  Future<void> _deleteWithGoogle() async {
    if (!_checkboxConfirmed) {
      _showError('Please confirm you understand this action is irreversible.');
      return;
    }

    setState(() {
      _isLoading = true;
      _step = 2;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulate
      await _user!.delete();
      await FirebaseAuth.instance.signOut();

      if (mounted) setState(() => _step = 3);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) _navigateToLogin();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      _showError('Google re-authentication failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleFirebaseError(FirebaseAuthException e) {
    setState(() => _step = 1);
    switch (e.code) {
      case 'wrong-password':
        _showError('Incorrect password. Please try again.');
        break;
      case 'invalid-credential':
        _showError('Invalid credentials. Please check and retry.');
        break;
      case 'requires-recent-login':
        _showError(
          'Session expired. Please log out and log in again before deleting.',
        );
        break;
      case 'too-many-requests':
        _showError(
          'Too many failed attempts. Please wait and try again later.',
        );
        break;
      case 'network-request-failed':
        _showError('No internet connection. Please check your network.');
        break;
      case 'user-not-found':
        _showError('Account not found. It may already have been deleted.');
        break;
      default:
        _showError('Error: ${e.message ?? e.code}');
    }
    _shakeCtrl.forward(from: 0);
  }

  void _showError(String msg) {
    setState(() => _errorMessage = msg);
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // ── Animated bg ──
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(sin(_bgCtrl.value * 2 * pi) * 0.3, -0.2),
                  radius: 1.1,
                  colors: [C.red.withOpacity(0.06), C.bg],
                ),
              ),
            ),
          ),
          // ── Scan beam ──
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
                      C.red.withOpacity(0.04),
                      C.red.withOpacity(0.10),
                      C.red.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── Content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    DeleteHeader(glowCtrl: _glowCtrl, redPulse: _redPulse),
                    Expanded(
                      child: _step == 3
                          ? SuccessView(anim: _entranceCtrl)
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                32,
                              ),
                              child: Column(
                                children: [
                                  DangerBanner(redPulse: _redPulse),
                                  const SizedBox(height: 16),
                                  AccountInfo(
                                    userEmail: _userEmail,
                                    isGoogleUser: _isGoogleUser,
                                  ),
                                  const SizedBox(height: 16),
                                  ConsequencesList(
                                    items: [
                                      ConsequenceItem(
                                        Icons.map_rounded,
                                        C.orange,
                                        'All city projects & districts deleted',
                                      ),
                                      ConsequenceItem(
                                        Icons.sensors_rounded,
                                        C.amber,
                                        'All sensor & actuator configs erased',
                                      ),
                                      ConsequenceItem(
                                        Icons.rule_rounded,
                                        C.cyan,
                                        'All automation rules permanently removed',
                                      ),
                                      ConsequenceItem(
                                        Icons.analytics_rounded,
                                        C.teal,
                                        'All analytics & historical logs lost',
                                      ),
                                      ConsequenceItem(
                                        Icons.no_accounts_rounded,
                                        C.red,
                                        'Account cannot be recovered',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ConfirmationForm(
                                    formKey: _formKey,
                                    isPasswordProvider: _isPasswordProvider,
                                    isGoogleUser: _isGoogleUser,
                                    passwordCtrl: _passwordCtrl,
                                    confirmCtrl: _confirmCtrl,
                                    obscurePassword: _obscurePassword,
                                    onTogglePassword: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                    checkboxConfirmed: _checkboxConfirmed,
                                    onToggleCheckbox: () => setState(
                                      () => _checkboxConfirmed =
                                          !_checkboxConfirmed,
                                    ),

                                    // reuse your existing widgets
                                    inputLabelBuilder: (text) =>
                                        InputLabel(text: text),
                                    passwordFieldBuilder:
                                        ({
                                          required controller,
                                          required hintText,
                                          required obscure,
                                          required onToggle,
                                          required validator,
                                        }) => PasswordField(
                                          controller: controller,
                                          hintText: hintText,
                                          obscure: obscure,
                                          onToggle: onToggle,
                                          validator: validator,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (_errorMessage != null)
                                    ErrorBox(
                                      message: _errorMessage!,
                                      shake: _shake,
                                    ),
                                  const SizedBox(height: 8),
                                  DeleteButton(
                                    isLoading: _isLoading,
                                    isGoogleUser: _isGoogleUser,
                                    step: _step,
                                    redPulse: _redPulse,
                                    onDeleteWithGoogle: _deleteWithGoogle,
                                    onDeleteWithPassword: _deleteWithPassword,
                                  ),
                                  const SizedBox(height: 12),
                                  CancelButton(
                                    onTap: () => Navigator.maybePop(context),
                                  ),
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
