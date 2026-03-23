import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Register ──────────────────────────────────────────────────────────────
  Future<User?> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Delete account ────────────────────────────────────────────────────────
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  // ── Current user ──────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ══════════════════════════════════════════════════════════════════════════
  //  FORGOT PASSWORD METHODS
  // ══════════════════════════════════════════════════════════════════════════

  /// Phase 0 → Phase 1
  /// Sends a Firebase password-reset email to [email].
  /// Throws [FirebaseAuthException] on failure so the UI can show the error.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Phase 1 → Phase 2
  /// Verifies that the [otp] (the out-of-band code from the reset link)
  /// is valid using Firebase's `verifyPasswordResetCode`.
  /// Returns the email address associated with the code on success.
  Future<String> verifyPasswordResetCode(String otp) async {
    // Firebase's OOB code is the `oobCode` query param from the reset link.
    // In the UI the user pastes / types it into the 6-box OTP field.
    final email = await _auth.verifyPasswordResetCode(otp.trim());
    return email;
  }

  /// Phase 2 → Phase 3
  /// Confirms the password reset using the [otp] code and [newPassword].
  Future<void> confirmPasswordReset({
    required String otp,
    required String newPassword,
  }) async {
    await _auth.confirmPasswordReset(
      code: otp.trim(),
      newPassword: newPassword,
    );
  }

  /// Convenience: checks whether an email is registered in Firebase Auth.
  /// Uses `fetchSignInMethodsForEmail` — returns true if at least one
  /// provider exists for that address.
  // Future<bool> isEmailRegistered(String email) async {
  //   final methods = await _auth.fetchSignInMethodsForEmail(email.trim());
  //   return methods.isNotEmpty;
  // }
  Future<bool> isEmailRegistered(String email) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: 'dummy');
      return true; // email exists
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return false;
      return true; // any other error assumes email exists
    }
  }
}
