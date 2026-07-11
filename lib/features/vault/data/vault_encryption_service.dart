import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';

/// AES-256-CBC encryption for EduVault document bytes.
///
/// Security model: the encryption key is a random 256-bit value generated on
/// first upload and stored at `/users/{uid}/vaultSecurity/encryption` —
/// covered by the existing Firestore rule that already restricts
/// `/users/{uid}/**` to its owner. Storing the key server-side (rather than
/// purely on-device) is a deliberate trade-off: it's what makes "restore on
/// a new device after login" (spec) possible at all. The practical access
/// gate for a student's documents is the PIN/biometric app lock
/// (`VaultAuthService`) plus Firebase Auth; the encryption's job is to
/// ensure the *stored blobs themselves* are never plain, readable files —
/// e.g. if Storage were ever misconfigured or a URL leaked, the bytes behind
/// it are still ciphertext.
class VaultEncryptionService {
  VaultEncryptionService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  enc.Key? _cachedKey;

  DocumentReference<Map<String, dynamic>> get _securityDoc {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user for EduVault.');
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('vaultSecurity')
        .doc('encryption');
  }

  Future<enc.Key> _getOrCreateKey() async {
    final cached = _cachedKey;
    if (cached != null) return cached;
    final snap = await _securityDoc.get();
    final existing = snap.data()?['keyBase64'] as String?;
    if (existing != null) {
      final key = enc.Key.fromBase64(existing);
      _cachedKey = key;
      return key;
    }
    final newKey = enc.Key.fromSecureRandom(32);
    await _securityDoc.set({
      'keyBase64': newKey.base64,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _cachedKey = newKey;
    return newKey;
  }

  /// Encrypts [plainBytes] and returns `IV (16 bytes) + ciphertext`, ready to
  /// upload as-is — [decryptBytes] reads the IV back off the front.
  Future<Uint8List> encryptBytes(Uint8List plainBytes) async {
    final key = await _getOrCreateKey();
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(plainBytes, iv: iv);
    return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
  }

  /// Reverses [encryptBytes] — expects the IV prepended to the ciphertext.
  Future<Uint8List> decryptBytes(Uint8List combined) async {
    if (combined.length <= 16) {
      throw const FormatException(
          'Encrypted payload is too short to contain an IV.');
    }
    final key = await _getOrCreateKey();
    final iv = enc.IV(Uint8List.sublistView(combined, 0, 16));
    final cipherBytes = Uint8List.sublistView(combined, 16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decrypted =
        encrypter.decryptBytes(enc.Encrypted(cipherBytes), iv: iv);
    return Uint8List.fromList(decrypted);
  }

  /// Clears the in-memory key cache (call on sign-out so a different
  /// account's key is never reused in the same app session).
  void clearCache() => _cachedKey = null;
}

final vaultEncryptionServiceProvider = Provider<VaultEncryptionService>(
  (ref) => VaultEncryptionService(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  ),
);
