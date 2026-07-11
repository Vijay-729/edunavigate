import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firebase_providers.dart';

/// Firestore-backed bookmark set for a given [kind] (e.g. "counselling",
/// "exams", "careers", "loans"), stored at
/// `/users/{uid}/bookmarks_{kind}/{itemId}`.
///
/// One implementation reused across Counselling Guide, Exam Universe,
/// Career Roadmap, and Education Loan instead of four near-identical
/// per-feature repositories (mirrors [BookmarkRepository] in scholarships /
/// `SavedCollegeRepository` in colleges, generalised over the collection
/// name).
class GenericBookmarkRepository {
  GenericBookmarkRepository(this._db, this._auth, this.kind);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final String kind;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('bookmarks_$kind');

  Stream<Set<String>> watchIds() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const {});
    return _col(uid)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  Future<void> toggle(String itemId, bool currentlyBookmarked) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      if (currentlyBookmarked) {
        await _col(uid).doc(itemId).delete();
      } else {
        await _col(uid)
            .doc(itemId)
            .set({'savedAt': FieldValue.serverTimestamp()});
      }
    } catch (e, st) {
      debugPrint('Bookmark ($kind) toggle failed: $e\n$st');
    }
  }
}

final counsellingBookmarkRepositoryProvider =
    Provider<GenericBookmarkRepository>((ref) => GenericBookmarkRepository(
          ref.watch(firestoreProvider),
          ref.watch(firebaseAuthProvider),
          'counselling',
        ));

final examBookmarkRepositoryProvider =
    Provider<GenericBookmarkRepository>((ref) => GenericBookmarkRepository(
          ref.watch(firestoreProvider),
          ref.watch(firebaseAuthProvider),
          'exams',
        ));

final careerRoadmapBookmarkRepositoryProvider =
    Provider<GenericBookmarkRepository>((ref) => GenericBookmarkRepository(
          ref.watch(firestoreProvider),
          ref.watch(firebaseAuthProvider),
          'careers',
        ));

final loanBookmarkRepositoryProvider =
    Provider<GenericBookmarkRepository>((ref) => GenericBookmarkRepository(
          ref.watch(firestoreProvider),
          ref.watch(firebaseAuthProvider),
          'loans',
        ));
