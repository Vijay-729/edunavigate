import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/career_roadmap_model.dart';
import 'career_roadmap_seed_data.dart';

/// Abstraction over "where career data comes from". Swapping in a
/// Firestore-backed implementation later (a `careerRoadmaps` collection
/// using [CareerRoadmapModel.fromMap]) requires no changes to services,
/// providers, or UI.
abstract class CareerRoadmapRepository {
  List<CareerRoadmapModel> getAll();
  CareerRoadmapModel? getById(String id);
}

class LocalCareerRoadmapRepository implements CareerRoadmapRepository {
  static final List<CareerRoadmapModel> _all =
      List.unmodifiable(CareerRoadmapSeedData.all);

  @override
  List<CareerRoadmapModel> getAll() => _all;

  @override
  CareerRoadmapModel? getById(String id) {
    for (final c in _all) {
      if (c.id == id) return c;
    }
    return null;
  }
}

final careerRoadmapRepositoryProvider =
    Provider<CareerRoadmapRepository>((ref) => LocalCareerRoadmapRepository());
