import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class AppAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AppAuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
  }

  Future<void> register(String email, String password) async {
    await _authService.register(email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  FORGOT PASSWORD
  // ══════════════════════════════════════════════════════════════════════════

  /// Phase 0 → 1: sends Firebase password-reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  /// Phase 1 → 2: validates the OOB reset code typed by the user.
  /// Returns the email address on success, throws on failure.
  Future<String> verifyPasswordResetCode(String otp) async {
    return await _authService.verifyPasswordResetCode(otp);
  }

  /// Phase 2 → 3: applies the new password using the OOB code.
  Future<void> confirmPasswordReset({
    required String otp,
    required String newPassword,
  }) async {
    await _authService.confirmPasswordReset(otp: otp, newPassword: newPassword);
  }

  /// Optional helper used in the email phase to give early feedback.
  Future<bool> isEmailRegistered(String email) async {
    return await _authService.isEmailRegistered(email);
  }
}
