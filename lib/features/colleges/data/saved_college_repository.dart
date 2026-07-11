import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';

/// Persists saved/favourited colleges and a recently-viewed trail at
/// `/users/{uid}/savedColleges/{collegeId}` and
/// `/users/{uid}/recentlyViewedColleges/{collegeId}` — same shape as
/// [BookmarkRepository] in the scholarships module.
class SavedCollegeRepository {
  SavedCollegeRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  static const _recentlyViewedLimit = 20;

  CollectionReference<Map<String, dynamic>> _saved(String uid) =>
      _db.collection('users').doc(uid).collection('savedColleges');

  CollectionReference<Map<String, dynamic>> _recentlyViewed(String uid) =>
      _db.collection('users').doc(uid).collection('recentlyViewedColleges');

  Stream<Set<String>> watchSavedIds() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const {});
    return _saved(uid)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  Stream<List<String>> watchRecentlyViewedIds() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _recentlyViewed(uid)
        .orderBy('viewedAt', descending: true)
        .limit(_recentlyViewedLimit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  Future<void> toggleSaved(String collegeId, bool currentlySaved) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      if (currentlySaved) {
        await _saved(uid).doc(collegeId).delete();
      } else {
        await _saved(uid).doc(collegeId).set({
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e, st) {
      debugPrint('College save toggle failed: $e\n$st');
    }
  }

  Future<void> recordView(String collegeId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _recentlyViewed(uid).doc(collegeId).set({
        'viewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      debugPrint('Recording recently-viewed college failed: $e\n$st');
    }
  }
}

final savedCollegeRepositoryProvider = Provider<SavedCollegeRepository>(
  (ref) => SavedCollegeRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  ),
);
