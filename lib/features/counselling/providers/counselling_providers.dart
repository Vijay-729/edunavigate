import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../data/counselling_repository.dart';
import '../models/counselling_model.dart';
import '../services/counselling_query_service.dart';

final counsellingSearchQueryProvider =
    StateProvider.autoDispose<String>((ref) => '');

final counsellingFilterProvider = StateProvider.autoDispose<CounsellingFilter>(
    (ref) => const CounsellingFilter());

final counsellingSortOrderProvider =
    StateProvider.autoDispose<CounsellingSortOrder>(
        (ref) => CounsellingSortOrder.relevance);

final allCounsellingProgramsProvider =
    Provider.autoDispose<List<CounsellingProgram>>(
        (ref) => ref.watch(counsellingRepositoryProvider).getAll());

final filteredCounsellingProvider =
    Provider.autoDispose<List<CounsellingProgram>>((ref) {
  final all = ref.watch(allCounsellingProgramsProvider);
  final query = ref.watch(counsellingSearchQueryProvider);
  final filter = ref.watch(counsellingFilterProvider);
  final sort = ref.watch(counsellingSortOrderProvider);

  var result = CounsellingQueryService.search(all, query);
  result = CounsellingQueryService.filter(result, filter);
  result = CounsellingQueryService.sort(result, sort);
  return result;
});

/// Programs with a dated event in the next 30 days, soonest first.
final upcomingCounsellingProvider =
    Provider.autoDispose<List<CounsellingProgram>>((ref) {
  final all = ref.watch(allCounsellingProgramsProvider);
  final now = DateTime.now();
  final horizon = now.add(const Duration(days: 30));
  final list = all.where((p) {
    final next = p.nextUpcomingEvent;
    return next != null && next.date.isBefore(horizon);
  }).toList()
    ..sort((a, b) =>
        a.nextUpcomingEvent!.date.compareTo(b.nextUpcomingEvent!.date));
  return list;
});

/// Programs with a dated event in the last 30 days — "currently active".
final recentCounsellingProvider =
    Provider.autoDispose<List<CounsellingProgram>>((ref) {
  final all = ref.watch(allCounsellingProgramsProvider);
  final now = DateTime.now();
  final horizon = now.subtract(const Duration(days: 30));
  final list = all.where((p) {
    final past = p.mostRecentPastEvent;
    return past != null && past.date.isAfter(horizon);
  }).toList()
    ..sort((a, b) =>
        b.mostRecentPastEvent!.date.compareTo(a.mostRecentPastEvent!.date));
  return list;
});

final counsellingBookmarkIdsProvider = StreamProvider.autoDispose<Set<String>>(
    (ref) => ref.watch(counsellingBookmarkRepositoryProvider).watchIds());

final savedCounsellingProvider =
    Provider.autoDispose<List<CounsellingProgram>>((ref) {
  final all = ref.watch(allCounsellingProgramsProvider);
  final ids =
      ref.watch(counsellingBookmarkIdsProvider).asData?.value ?? const {};
  return all.where((p) => ids.contains(p.id)).toList();
});

final counsellingByIdProvider =
    Provider.autoDispose.family<CounsellingProgram?, String>((ref, id) {
  return ref.watch(counsellingRepositoryProvider).getById(id);
});

/// All dated events across every programme — feeds the shared calendar.
final allCounsellingDateEventsProvider = Provider.autoDispose<
    List<({CounsellingProgram program, CounsellingDateEvent event})>>((ref) {
  final all = ref.watch(allCounsellingProgramsProvider);
  return all
      .expand((p) => p.dateEvents.map((e) => (program: p, event: e)))
      .toList();
});
