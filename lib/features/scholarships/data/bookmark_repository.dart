import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';

/// Persists scholarship bookmarks at `/users/{uid}/bookmarks/{scholarshipId}`.
class BookmarkRepository {
  BookmarkRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('bookmarks');

  Stream<Set<String>> watchBookmarkIds() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const {});
    return _col(uid).snapshots().map(
          (snap) => snap.docs.map((d) => d.id).toSet(),
        );
  }

  Future<void> toggle(String scholarshipId, bool currentlyBookmarked) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      if (currentlyBookmarked) {
        await _col(uid).doc(scholarshipId).delete();
      } else {
        await _col(uid).doc(scholarshipId).set({
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e, st) {
      debugPrint('Bookmark toggle failed: $e\n$st');
    }
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (ref) => BookmarkRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  ),
);
