import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/local_profile_cache.dart';
import '../../../core/providers/firebase_providers.dart';

/// Wraps Firebase Authentication. Throws [AuthException] with human-readable
/// messages so the UI never has to parse raw FirebaseAuthException codes.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async {
    await LocalProfileCache.clear();
    await _auth.signOut();
  }

  String _messageFor(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'That email is already registered. Try logging in.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);
