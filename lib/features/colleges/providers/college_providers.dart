import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/providers/profile_providers.dart';
import '../data/college_repository.dart';
import '../data/saved_college_repository.dart';
import '../models/college_model.dart';
import '../models/student_stream.dart';
import '../services/ai_match_service.dart';
import '../services/college_query_service.dart';

/// Manual override so a student can browse a stream other than the one
/// inferred from their profile (or pick one if inference fails).
final streamOverrideProvider =
    StateProvider.autoDispose<StudentStream?>((ref) => null);

/// Best-effort guess at the student's stream from their free-text profile
/// `branch` field (see [StreamClassifier]).
final detectedStreamProvider = Provider.autoDispose<StudentStream?>((ref) {
  final profile = ref.watch(currentProfileProvider).asData?.value;
  return StreamClassifier.fromBranchText(profile?.branch);
});

/// The stream actually driving College Explorer/Predictor content —
/// manual override wins, otherwise the detected stream. `null` means the
/// UI should prompt the student to pick one explicitly.
final activeStreamProvider = Provider.autoDispose<StudentStream?>((ref) {
  return ref.watch(streamOverrideProvider) ?? ref.watch(detectedStreamProvider);
});

/// Every college relevant to the active stream — the gate that stops
/// College Explorer from ever showing "every college in India".
final streamCollegesProvider = Provider.autoDispose<List<CollegeModel>>((ref) {
  final stream = ref.watch(activeStreamProvider);
  if (stream == null) return const [];
  return ref.watch(collegeRepositoryProvider).getByStream(stream);
});

final collegeSearchQueryProvider =
    StateProvider.autoDispose<String>((ref) => '');

final collegeFilterProvider =
    StateProvider.autoDispose<CollegeFilter>((ref) => const CollegeFilter());

final collegeSortOrderProvider = StateProvider.autoDispose<CollegeSortOrder>(
    (ref) => CollegeSortOrder.relevance);

/// Preferences fed into [AiMatchService] — combines the student's saved
/// profile (preferred cities/budget) with whatever they've set in filters.
final matchPreferencesProvider =
    Provider.autoDispose<CollegeMatchPreferences>((ref) {
  final profile = ref.watch(currentProfileProvider).asData?.value;
  final filter = ref.watch(collegeFilterProvider);
  return CollegeMatchPreferences(
    preferredCourseCategory: filter.courseCategory,
    preferredState: filter.state ?? profile?.state,
    preferredCities: profile?.preferredCities ?? const [],
    budgetPerYear: filter.maxFeesPerYear ??
        int.tryParse(profile?.budget?.replaceAll(RegExp(r'[^0-9]'), '') ?? ''),
    hostelRequired: filter.hostelOnly,
    examId: filter.examIds.isNotEmpty ? filter.examIds.first : null,
  );
});

/// AI match % for every college in the active stream, keyed by college id.
final collegeMatchScoresProvider =
    Provider.autoDispose<Map<String, double>>((ref) {
  final colleges = ref.watch(streamCollegesProvider);
  final prefs = ref.watch(matchPreferencesProvider);
  return {
    for (final c in colleges) c.id: AiMatchService.computeMatch(c, prefs),
  };
});

final aiRecommendedIdsProvider = Provider.autoDispose<Set<String>>((ref) {
  final colleges = ref.watch(streamCollegesProvider);
  final prefs = ref.watch(matchPreferencesProvider);
  return AiMatchService.topRecommendedIds(colleges, prefs);
});

/// Full search → filter → sort pipeline behind the results screen.
final filteredCollegesProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  final colleges = ref.watch(streamCollegesProvider);
  final query = ref.watch(collegeSearchQueryProvider);
  final filter = ref.watch(collegeFilterProvider);
  final sortOrder = ref.watch(collegeSortOrderProvider);
  final aiRecommended = ref.watch(aiRecommendedIdsProvider);

  var result = CollegeQueryService.search(colleges, query);
  result = CollegeQueryService.filter(result, filter, aiRecommended);
  result = CollegeQueryService.sort(result, sortOrder);
  return result;
});

final trendingCollegesProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  return CollegeQueryService.trending(ref.watch(streamCollegesProvider));
});

final topGovernmentCollegesProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  return CollegeQueryService.topGovernment(ref.watch(streamCollegesProvider));
});

final topPrivateCollegesProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  return CollegeQueryService.topPrivate(ref.watch(streamCollegesProvider));
});

final topRankedCollegesProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  return CollegeQueryService.topRanked(ref.watch(streamCollegesProvider));
});

/// "Recommended For You" rail — top AI-matched colleges, ranked by score.
final recommendedForYouProvider =
    Provider.autoDispose<List<CollegeModel>>((ref) {
  final colleges = ref.watch(streamCollegesProvider);
  final scores = ref.watch(collegeMatchScoresProvider);
  final sorted = List<CollegeModel>.from(colleges)
    ..sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));
  return sorted.take(10).toList();
});

/// Live set of saved/favourited college ids for the signed-in student.
final savedCollegeIdsProvider = StreamProvider.autoDispose<Set<String>>((ref) {
  return ref.watch(savedCollegeRepositoryProvider).watchSavedIds();
});

/// Ids of the most recently viewed colleges, most-recent first.
final recentlyViewedCollegeIdsProvider =
    StreamProvider.autoDispose<List<String>>((ref) {
  return ref.watch(savedCollegeRepositoryProvider).watchRecentlyViewedIds();
});

/// Up to 4 colleges selected for the side-by-side comparison screen.
class CompareListNotifier extends StateNotifier<List<String>> {
  CompareListNotifier() : super(const []);

  static const maxCompare = 4;

  /// Returns false when the list is already full and [id] wasn't in it.
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

final compareListProvider =
    StateNotifierProvider.autoDispose<CompareListNotifier, List<String>>(
  (ref) => CompareListNotifier(),
);

/// Resolves a college by id from the full catalogue (not just the active
/// stream) so saved/compare/recently-viewed lists work even if the student
/// switches streams afterwards.
final collegeByIdProvider =
    Provider.autoDispose.family<CollegeModel?, String>((ref, id) {
  return ref.watch(collegeRepositoryProvider).getById(id);
});
