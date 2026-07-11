import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../../core/providers/firebase_providers.dart';

enum VaultBiometricResult {
  success,
  failed,
  notEnrolled,
  lockedOut,
  notAvailable
}

/// PIN + biometric (fingerprint/Face) lock for EduVault.
///
/// The PIN is never stored in plaintext: only its salted SHA-256 hash is
/// kept, in [FlutterSecureStorage] (Keychain/Keystore) for fast local checks
/// and mirrored to `/users/{uid}/vaultSecurity/pin` (owner-only, per the
/// existing Firestore rules) so "Setup EduVault" doesn't have to be repeated
/// after a reinstall or on a new device. Biometrics are handled entirely by
/// the OS via `local_auth` — this app never sees fingerprint/face data.
class VaultAuthService {
  VaultAuthService(
      this._firestore, this._auth, this._secureStorage, this._localAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user for EduVault.');
    return uid;
  }

  String _pinKey(String uid) => 'vault_pin_hash_$uid';
  String _biometricKey(String uid) => 'vault_biometric_enabled_$uid';

  DocumentReference<Map<String, dynamic>> _securityDoc(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('vaultSecurity')
      .doc('pin');

  String _hashPin(String pin, String uid) {
    final digest = sha256.convert(utf8.encode('$uid:$pin:eduvault-pin-v1'));
    return digest.toString();
  }

  /// Whether the student has finished "Setup EduVault" at least once —
  /// checks the fast local cache first, then Firestore (covers a reinstall/
  /// new device where the secure-storage cache is empty but the account has
  /// already set up EduVault before).
  Future<bool> isSetupComplete() async {
    final uid = _uid;
    final local = await _secureStorage.read(key: _pinKey(uid));
    if (local != null) return true;
    final snap = await _securityDoc(uid).get();
    final hash = snap.data()?['pinHash'] as String?;
    if (hash != null) {
      await _secureStorage.write(key: _pinKey(uid), value: hash);
      return true;
    }
    return false;
  }

  Future<void> setPin(String pin) async {
    final uid = _uid;
    final hash = _hashPin(pin, uid);
    await _secureStorage.write(key: _pinKey(uid), value: hash);
    await _securityDoc(uid).set(
      {'pinHash': hash, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<bool> verifyPin(String pin) async {
    final uid = _uid;
    final hash = _hashPin(pin, uid);
    var stored = await _secureStorage.read(key: _pinKey(uid));
    if (stored == null) {
      stored = (await _securityDoc(uid).get()).data()?['pinHash'] as String?;
      if (stored != null) {
        await _secureStorage.write(key: _pinKey(uid), value: stored);
      }
    }
    return stored != null && stored == hash;
  }

  Future<bool> get biometricsAvailable async {
    try {
      return await _localAuth.isDeviceSupported() &&
          await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> get faceUnlockAvailable async =>
      (await availableBiometrics()).contains(BiometricType.face);

  Future<bool> isBiometricEnabled() async {
    final v = await _secureStorage.read(key: _biometricKey(_uid));
    return v == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) =>
      _secureStorage.write(key: _biometricKey(_uid), value: enabled.toString());

  Future<VaultBiometricResult> authenticateWithBiometrics() async {
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: 'Unlock your EduVault documents',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      return ok ? VaultBiometricResult.success : VaultBiometricResult.failed;
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notEnrolled:
          return VaultBiometricResult.notEnrolled;
        case auth_error.lockedOut:
        case auth_error.permanentlyLockedOut:
          return VaultBiometricResult.lockedOut;
        case auth_error.notAvailable:
        case auth_error.passcodeNotSet:
          return VaultBiometricResult.notAvailable;
        default:
          return VaultBiometricResult.failed;
      }
    } catch (_) {
      return VaultBiometricResult.failed;
    }
  }

  /// "Delete Vault" — clears the PIN/biometric flag locally and on the
  /// server. Callers are responsible for also deleting the documents/
  /// encryption key (see `VaultRepository.deleteEverything`).
  Future<void> resetSecurity() async {
    final uid = _uid;
    await _secureStorage.delete(key: _pinKey(uid));
    await _secureStorage.delete(key: _biometricKey(uid));
    await _securityDoc(uid).delete();
  }
}

final _secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final _localAuthProvider = Provider<LocalAuthentication>(
  (ref) => LocalAuthentication(),
);

final vaultAuthServiceProvider = Provider<VaultAuthService>(
  (ref) => VaultAuthService(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    ref.watch(_secureStorageProvider),
    ref.watch(_localAuthProvider),
  ),
);
