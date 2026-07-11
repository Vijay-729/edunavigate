import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/user_profile.dart';

/// Thrown by [ProfileRepository] with a human-readable message so the UI never
/// has to parse raw Firebase exceptions.
class ProfileException implements Exception {
  ProfileException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Reads/writes the `/users/{uid}` document and the profile photo in Storage.
class ProfileRepository {
  ProfileRepository(this._db, this._storage);

  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  /// Uploads the profile photo and returns its download URL, or `null` if the
  /// upload fails. A failed photo upload must never block saving the rest of
  /// the profile, so callers treat `null` as "no photo this time".
  Future<String?> uploadProfilePhoto(String uid, File file) async {
    try {
      final ref = _storage.ref('users/$uid/profile.jpg');
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      return await ref.getDownloadURL();
    } catch (e, st) {
      debugPrint('Profile photo upload failed: $e\n$st');
      return null;
    }
  }

  /// Creates or merges the user profile document.
  Future<void> saveProfile(UserProfile profile) async {
    try {
      final data = profile.toMap()
        ..['updatedAt'] = FieldValue.serverTimestamp();

      final doc = _userDoc(profile.uid);
      final exists = (await doc.get()).exists;
      if (!exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }
      await doc.set(data, SetOptions(merge: true));
    } on FirebaseException catch (e, st) {
      debugPrint('saveProfile failed: ${e.code} ${e.message}\n$st');
      throw ProfileException(_messageFor(e.code));
    } catch (e, st) {
      debugPrint('saveProfile failed: $e\n$st');
      throw ProfileException('Could not save your profile. Please try again.');
    }
  }

  /// Flags that the user has finished the self-assessment at least once.
  Future<void> markAssessmentComplete(String uid) async {
    try {
      await _userDoc(uid).set({
        'assessmentCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e, st) {
      debugPrint('markAssessmentComplete failed: ${e.code}\n$st');
      throw ProfileException(_messageFor(e.code));
    }
  }

  /// Persists the top assessment category keys so Career Explorer can rank
  /// careers even after the autoDispose controller is cleared.
  Future<void> saveAssessmentStrengths(
      String uid, List<String> strengths) async {
    try {
      await _userDoc(uid).set({
        'assessmentCompleted': true,
        'assessmentStrengths': strengths,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e, st) {
      debugPrint('saveAssessmentStrengths failed: ${e.code}\n$st');
    }
  }

  Future<UserProfile?> fetchProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists) return null;
    return UserProfile.fromMap(uid, snap.data()!);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _userDoc(uid).snapshots().map(
          (snap) => snap.exists ? UserProfile.fromMap(uid, snap.data()!) : null,
        );
  }

  String _messageFor(String code) {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to save this profile. '
            'Check Firestore security rules.';
      case 'unavailable':
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Could not save your profile. Please try again.';
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
  ),
);
