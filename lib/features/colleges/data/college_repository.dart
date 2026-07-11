import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/college_model.dart';
import '../models/student_stream.dart';
import 'seed/agriculture_colleges_data.dart';
import 'seed/arts_law_design_colleges_data.dart';
import 'seed/commerce_colleges_data.dart';
import 'seed/engineering_colleges_data.dart';
import 'seed/medical_colleges_data.dart';

/// Abstraction over "where college data comes from". [LocalCollegeRepository]
/// serves the bundled seed dataset today; swapping in a Firestore-backed
/// implementation later (reading a `colleges` collection with the same
/// [CollegeModel.fromMap] shape) requires no changes to services, providers,
/// or UI — only a different binding for [collegeRepositoryProvider].
abstract class CollegeRepository {
  List<CollegeModel> getAll();
  List<CollegeModel> getByStream(StudentStream stream);
  CollegeModel? getById(String id);
}

class LocalCollegeRepository implements CollegeRepository {
  static final List<CollegeModel> _all = List.unmodifiable([
    ...EngineeringCollegesData.all,
    ...MedicalCollegesData.all,
    ...CommerceCollegesData.all,
    ...ArtsLawDesignCollegesData.all,
    ...AgricultureCollegesData.all,
  ]);

  @override
  List<CollegeModel> getAll() => _all;

  @override
  List<CollegeModel> getByStream(StudentStream stream) {
    final eligible = stream.eligibleCategories.toSet();
    return _all
        .where((college) => college.categories.any(eligible.contains))
        .toList();
  }

  @override
  CollegeModel? getById(String id) {
    for (final college in _all) {
      if (college.id == id) return college;
    }
    return null;
  }
}

final collegeRepositoryProvider = Provider<CollegeRepository>(
  (ref) => LocalCollegeRepository(),
);
