import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/counselling_model.dart';
import 'counselling_seed_data.dart';

/// Abstraction over "where counselling data comes from". Swapping in a
/// Firestore-backed implementation later (a `counsellingPrograms` collection
/// using [CounsellingProgram.fromMap]) requires no changes to services,
/// providers, or UI.
abstract class CounsellingRepository {
  List<CounsellingProgram> getAll();
  CounsellingProgram? getById(String id);
}

class LocalCounsellingRepository implements CounsellingRepository {
  static final List<CounsellingProgram> _all =
      List.unmodifiable(CounsellingSeedData.all);

  @override
  List<CounsellingProgram> getAll() => _all;

  @override
  CounsellingProgram? getById(String id) {
    for (final p in _all) {
      if (p.id == id) return p;
    }
    return null;
  }
}

final counsellingRepositoryProvider = Provider<CounsellingRepository>(
  (ref) => LocalCounsellingRepository(),
);
