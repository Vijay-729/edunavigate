import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../data/career_roadmap_repository.dart';
import '../models/career_roadmap_model.dart';
import '../services/career_match_service.dart';
import '../services/career_query_service.dart';

final careerSearchQueryProvider =
    StateProvider.autoDispose<String>((ref) => '');

final careerFilterProvider =
    StateProvider.autoDispose<CareerFilter>((ref) => const CareerFilter());

final careerSortOrderProvider = StateProvider.autoDispose<CareerSortOrder>(
    (ref) => CareerSortOrder.relevance);

final allCareersProvider = Provider.autoDispose<List<CareerRoadmapModel>>(
    (ref) => ref.watch(careerRoadmapRepositoryProvider).getAll());

final filteredCareersProvider =
    Provider.autoDispose<List<CareerRoadmapModel>>((ref) {
  final all = ref.watch(allCareersProvider);
  final query = ref.watch(careerSearchQueryProvider);
  final filter = ref.watch(careerFilterProvider);
  final sort = ref.watch(careerSortOrderProvider);

  var result = CareerQueryService.search(all, query);
  result = CareerQueryService.filter(result, filter);
  result = CareerQueryService.sort(result, sort);
  return result;
});

final careerByIdProvider =
    Provider.autoDispose.family<CareerRoadmapModel?, String>((ref, id) {
  return ref.watch(careerRoadmapRepositoryProvider).getById(id);
});

final careerBookmarkIdsProvider = StreamProvider.autoDispose<Set<String>>(
    (ref) => ref.watch(careerRoadmapBookmarkRepositoryProvider).watchIds());

final savedCareersProvider =
    Provider.autoDispose<List<CareerRoadmapModel>>((ref) {
  final all = ref.watch(allCareersProvider);
  final ids = ref.watch(careerBookmarkIdsProvider).asData?.value ?? const {};
  return all.where((c) => ids.contains(c.id)).toList();
});

/// Selected assessment option tags, keyed by question id — drives the
/// career-match ranking once the student finishes the quick assessment.
class CareerAssessmentAnswersNotifier
    extends StateNotifier<Map<String, Set<String>>> {
  CareerAssessmentAnswersNotifier() : super(const {});

  void answer(String questionId, Set<String> tags) {
    state = {...state, questionId: tags};
  }

  void reset() => state = const {};

  Set<String> get allSelectedTags => state.values.expand((t) => t).toSet();
}

final careerAssessmentAnswersProvider = StateNotifierProvider.autoDispose<
    CareerAssessmentAnswersNotifier,
    Map<String, Set<String>>>((ref) => CareerAssessmentAnswersNotifier());

/// Careers ranked by overlap with the student's assessment answers. Falls
/// back to popularity ranking before the assessment is completed.
final recommendedCareersProvider =
    Provider.autoDispose<List<CareerRoadmapModel>>((ref) {
  final all = ref.watch(allCareersProvider);
  final answers = ref.watch(careerAssessmentAnswersProvider);
  final tags = answers.values.expand((t) => t).toSet();
  if (tags.isEmpty) {
    final sorted = List.of(all)
      ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    return sorted;
  }
  return CareerMatchService.rank(all, tags);
});

final careerMatchScoresProvider =
    Provider.autoDispose<Map<String, double>>((ref) {
  final all = ref.watch(allCareersProvider);
  final answers = ref.watch(careerAssessmentAnswersProvider);
  final tags = answers.values.expand((t) => t).toSet();
  return {for (final c in all) c.id: CareerMatchService.computeMatch(c, tags)};
});

/// Up to 3 careers selected for side-by-side comparison (MBBS vs BDS style).
class CareerCompareListNotifier extends StateNotifier<List<String>> {
  CareerCompareListNotifier() : super(const []);

  static const maxCompare = 3;

  bool toggle(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toList();
      return true;
    }
    if (state.length >= maxCompare) return false;
    state = [...state, id];
    return true;
  }

  void clear() => state = const [];
}

final careerCompareListProvider =
    StateNotifierProvider.autoDispose<CareerCompareListNotifier, List<String>>(
        (ref) => CareerCompareListNotifier());
