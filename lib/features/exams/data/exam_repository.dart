import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exam_profile_model.dart';
import 'exam_universe_seed_data.dart';

/// Abstraction over "where exam data comes from". Swapping in a
/// Firestore-backed implementation later (an `examProfiles` collection
/// using [ExamProfileModel.fromMap]) requires no changes to services,
/// providers, or UI.
abstract class ExamRepository {
  List<ExamProfileModel> getAll();
  ExamProfileModel? getById(String id);
}

class LocalExamRepository implements ExamRepository {
  static final List<ExamProfileModel> _all =
      List.unmodifiable(ExamUniverseSeedData.all);

  @override
  List<ExamProfileModel> getAll() => _all;

  @override
  ExamProfileModel? getById(String id) {
    for (final e in _all) {
      if (e.id == id) return e;
    }
    return null;
  }
}

final examRepositoryProvider =
    Provider<ExamRepository>((ref) => LocalExamRepository());
