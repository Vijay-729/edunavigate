import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/syllabus_models.dart';

/// Firestore paths (board-aware):
///   Progress : users/{uid}/syllabus_progress/{board}_{classCode}_{subjectCode}
///   Notes    : syllabus_content/{board}_{classCode}_{subjectCode}/notes/{id}
///   PYQs     : syllabus_content/{board}_{classCode}_{subjectCode}/pyqs/{id}
///
/// The board code is the Board.code value: 'cbse' | 'icse' | 'state'.
/// If board is omitted (legacy calls), 'cbse' is used.
class SyllabusRepository {
  SyllabusRepository(this._db);

  final FirebaseFirestore _db;

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _docId(Board board, String classCode, String subjectCode) =>
      '${board.code}_${classCode}_$subjectCode';

  String _contentDocId(Board board, String classCode, String subjectCode) =>
      '${board.code}_${classCode}_$subjectCode';

  DocumentReference<Map<String, dynamic>> _progressDoc(
      String uid, Board board, String classCode, String subjectCode) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('syllabus_progress')
        .doc(_docId(board, classCode, subjectCode));
  }

  // ─── Progress ─────────────────────────────────────────────────────────────

  Stream<Map<String, bool>> watchProgress({
    required String uid,
    required Board board,
    required String classCode,
    required String subjectCode,
  }) {
    return _progressDoc(uid, board, classCode, subjectCode)
        .snapshots()
        .map((snap) {
      final data = snap.data();
      if (data == null) return {};
      return data.map((k, v) => MapEntry(k, v == true));
    });
  }

  Future<void> setTopicDone({
    required String uid,
    required Board board,
    required String classCode,
    required String subjectCode,
    required String key,
    required bool value,
  }) {
    return _progressDoc(uid, board, classCode, subjectCode)
        .set({key: value}, SetOptions(merge: true));
  }

  /// Streams all progress docs that start with "{board}_{classCode}_".
  Stream<Map<String, Map<String, bool>>> watchClassProgress({
    required String uid,
    required Board board,
    required String classCode,
  }) {
    final prefix = '${board.code}_$classCode';
    return _db
        .collection('users')
        .doc(uid)
        .collection('syllabus_progress')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: prefix)
        .where(FieldPath.documentId, isLessThan: '$prefix￿')
        .snapshots()
        .map((snap) {
      final result = <String, Map<String, bool>>{};
      for (final doc in snap.docs) {
        result[doc.id] = doc.data().map((k, v) => MapEntry(k, v == true));
      }
      return result;
    });
  }

  // ─── Content (Notes & PYQs) ───────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _contentCol(
      Board board, String classCode, String subjectCode, String type) {
    return _db
        .collection('syllabus_content')
        .doc(_contentDocId(board, classCode, subjectCode))
        .collection(type); // 'notes' or 'pyqs'
  }

  /// Fetches notes for a chapter (chapterId == null → all chapters).
  Future<List<ContentItem>> fetchNotes({
    required Board board,
    required String classCode,
    required String subjectCode,
    String? chapterId,
  }) async {
    Query<Map<String, dynamic>> q =
        _contentCol(board, classCode, subjectCode, 'notes');
    if (chapterId != null && chapterId.isNotEmpty) {
      q = q.where('chapterId', isEqualTo: chapterId);
    }
    final snap = await q.get();
    return snap.docs.map((d) => ContentItem.fromMap(d.id, d.data())).toList();
  }

  /// Fetches PYQs for a chapter (chapterId == null → all chapters).
  /// Pass pyqBoard to filter by exam board name (e.g. 'CBSE 2023').
  Future<List<ContentItem>> fetchPyqs({
    required Board board,
    required String classCode,
    required String subjectCode,
    String? chapterId,
    String? pyqBoard,
  }) async {
    Query<Map<String, dynamic>> q =
        _contentCol(board, classCode, subjectCode, 'pyqs');
    if (chapterId != null && chapterId.isNotEmpty) {
      q = q.where('chapterId', isEqualTo: chapterId);
    }
    if (pyqBoard != null && pyqBoard.isNotEmpty) {
      q = q.where('board', isEqualTo: pyqBoard);
    }
    final snap = await q.get();
    return snap.docs.map((d) => ContentItem.fromMap(d.id, d.data())).toList();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final syllabusRepositoryProvider = Provider<SyllabusRepository>((ref) {
  return SyllabusRepository(ref.watch(firestoreProvider));
});
