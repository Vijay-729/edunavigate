import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../data/exam_repository.dart';
import '../models/exam_profile_model.dart';
import '../services/exam_query_service.dart';

final examSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final examFilterProvider =
    StateProvider.autoDispose<ExamFilter>((ref) => const ExamFilter());

final examSortOrderProvider =
    StateProvider.autoDispose<ExamSortOrder>((ref) => ExamSortOrder.relevance);

final allExamsProvider = Provider.autoDispose<List<ExamProfileModel>>(
    (ref) => ref.watch(examRepositoryProvider).getAll());

final filteredExamsProvider =
    Provider.autoDispose<List<ExamProfileModel>>((ref) {
  final all = ref.watch(allExamsProvider);
  final query = ref.watch(examSearchQueryProvider);
  final filter = ref.watch(examFilterProvider);
  final sort = ref.watch(examSortOrderProvider);

  var result = ExamQueryService.search(all, query);
  result = ExamQueryService.filter(result, filter);
  result = ExamQueryService.sort(result, sort);
  return result;
});

final upcomingExamsProvider =
    Provider.autoDispose<List<ExamProfileModel>>((ref) {
  final all = ref.watch(allExamsProvider);
  final now = DateTime.now();
  final horizon = now.add(const Duration(days: 45));
  final list = all.where((e) {
    final next = e.nextUpcomingEvent;
    return next != null && next.date.isBefore(horizon);
  }).toList()
    ..sort((a, b) =>
        a.nextUpcomingEvent!.date.compareTo(b.nextUpcomingEvent!.date));
  return list;
});

final trendingExamsProvider =
    Provider.autoDispose<List<ExamProfileModel>>((ref) {
  final all = List<ExamProfileModel>.from(ref.watch(allExamsProvider));
  all.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
  return all;
});

final examBookmarkIdsProvider = StreamProvider.autoDispose<Set<String>>(
    (ref) => ref.watch(examBookmarkRepositoryProvider).watchIds());

final savedExamsProvider = Provider.autoDispose<List<ExamProfileModel>>((ref) {
  final all = ref.watch(allExamsProvider);
  final ids = ref.watch(examBookmarkIdsProvider).asData?.value ?? const {};
  return all.where((e) => ids.contains(e.id)).toList();
});

final examByIdProvider =
    Provider.autoDispose.family<ExamProfileModel?, String>((ref, id) {
  return ref.watch(examRepositoryProvider).getById(id);
});

/// Up to 3 exams selected for side-by-side comparison (JEE vs CUET, etc).
class ExamCompareListNotifier extends StateNotifier<List<String>> {
  ExamCompareListNotifier() : super(const []);

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

final examCompareListProvider =
    StateNotifierProvider.autoDispose<ExamCompareListNotifier, List<String>>(
        (ref) => ExamCompareListNotifier());

/// All dated events across every exam — feeds the shared Exam Calendar.
final allExamDateEventsProvider =
    Provider.autoDispose<List<({ExamProfileModel exam, ExamDateEvent event})>>(
        (ref) {
  final all = ref.watch(allExamsProvider);
  return all
      .expand((e) => e.dateEvents.map((d) => (exam: e, event: d)))
      .toList();
});
