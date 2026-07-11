import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/prediction_model.dart';
import '../models/student_stream.dart';

/// A lightweight, persisted summary of a generated [PredictionResult] —
/// enough to list past reports without re-running the prediction engine.
class SavedPredictionReport {
  final String id;
  final String streamLabel;
  final String examId;
  final int? examRank;
  final int dreamCount;
  final int targetCount;
  final int safeCount;
  final DateTime? createdAt;

  const SavedPredictionReport({
    required this.id,
    required this.streamLabel,
    required this.examId,
    required this.examRank,
    required this.dreamCount,
    required this.targetCount,
    required this.safeCount,
    this.createdAt,
  });

  factory SavedPredictionReport.fromDoc(
    String id,
    Map<String, dynamic> map,
  ) {
    return SavedPredictionReport(
      id: id,
      streamLabel: map['streamLabel'] as String? ?? '',
      examId: map['examId'] as String? ?? '',
      examRank: map['examRank'] as int?,
      dreamCount: map['dreamCount'] as int? ?? 0,
      targetCount: map['targetCount'] as int? ?? 0,
      safeCount: map['safeCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

/// Persists prediction reports at `/users/{uid}/predictionReports/{autoId}`
/// so a student can revisit past "Predict" runs (spec: "Save Prediction").
class PredictorReportRepository {
  PredictorReportRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('predictionReports');

  Stream<List<SavedPredictionReport>> watchReports() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _col(uid).orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => SavedPredictionReport.fromDoc(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> saveReport(PredictionResult result) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _col(uid).add({
        'streamLabel': result.input.stream.label,
        'examId': result.input.examId,
        'examRank': result.input.examRank,
        'dreamCount': result.dreamColleges.length,
        'targetCount': result.targetColleges.length,
        'safeCount': result.safeColleges.length,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      debugPrint('Saving prediction report failed: $e\n$st');
    }
  }

  Future<void> deleteReport(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _col(uid).doc(id).delete();
    } catch (e, st) {
      debugPrint('Deleting prediction report failed: $e\n$st');
    }
  }
}

final predictorReportRepositoryProvider = Provider<PredictorReportRepository>(
  (ref) => PredictorReportRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  ),
);
