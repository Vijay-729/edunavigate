import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/study_task.dart';

class StudyTaskRepository {
  StudyTaskRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('study_tasks');

  Stream<List<StudyTask>> watchTasksForDay(String uid, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    return _col(uid)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
            isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => StudyTask.fromMap(d.data())).toList());
  }

  Stream<List<StudyTask>> watchTasksForWeek(String uid, DateTime weekStart) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));

    return _col(uid)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
            isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => StudyTask.fromMap(d.data())).toList());
  }

  Future<void> addTask(String uid, StudyTask task) async {
    await _col(uid).doc(task.id).set(task.toMap());
  }

  Future<void> toggleComplete(String uid, StudyTask task) async {
    await _col(uid).doc(task.id).update({'isCompleted': !task.isCompleted});
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _col(uid).doc(taskId).delete();
  }
}

final studyTaskRepositoryProvider = Provider<StudyTaskRepository>(
  (ref) => StudyTaskRepository(ref.watch(firestoreProvider)),
);
