import '../models/exam_category.dart';
import '../models/exam_profile_model.dart';

enum ExamSortOrder {
  relevance,
  mostPopular,
  nearestDate,
  alphabetical,
  easiestFirst
}

extension ExamSortOrderX on ExamSortOrder {
  String get label {
    switch (this) {
      case ExamSortOrder.relevance:
        return 'Relevance';
      case ExamSortOrder.mostPopular:
        return 'Most Popular';
      case ExamSortOrder.nearestDate:
        return 'Nearest Date';
      case ExamSortOrder.alphabetical:
        return 'A–Z';
      case ExamSortOrder.easiestFirst:
        return 'Easiest First';
    }
  }
}

class ExamFilter {
  final String query;
  final ExamCategory? category;
  final ExamDifficulty? difficulty;
  final ExamApplicationStatus? status;
  final ExamMode? mode;
  final int? month; // 1-12, filters by any dated event falling in this month
  final String? state; // exact match against ExamProfileModel.state

  const ExamFilter({
    this.query = '',
    this.category,
    this.difficulty,
    this.status,
    this.mode,
    this.month,
    this.state,
  });

  bool get isEmpty =>
      query.isEmpty &&
      category == null &&
      difficulty == null &&
      status == null &&
      mode == null &&
      month == null &&
      state == null;

  ExamFilter copyWith({
    String? query,
    ExamCategory? category,
    bool clearCategory = false,
    ExamDifficulty? difficulty,
    bool clearDifficulty = false,
    ExamApplicationStatus? status,
    bool clearStatus = false,
    ExamMode? mode,
    bool clearMode = false,
    int? month,
    bool clearMonth = false,
    String? state,
    bool clearState = false,
  }) {
    return ExamFilter(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      status: clearStatus ? null : (status ?? this.status),
      mode: clearMode ? null : (mode ?? this.mode),
      month: clearMonth ? null : (month ?? this.month),
      state: clearState ? null : (state ?? this.state),
    );
  }
}

/// Pure search/filter/sort logic for exam profiles.
class ExamQueryService {
  ExamQueryService._();

  static List<ExamProfileModel> search(
      List<ExamProfileModel> items, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((e) {
      final haystack = '${e.shortName} ${e.fullName} ${e.conductingBody} '
              '${e.careerOpportunities.join(' ')} ${e.topCollegesAccepting.join(' ')} '
              '${e.category.label} ${e.state ?? ''} ${e.subjects.join(' ')} '
              '${e.eligibility} ${e.educationalQualification}'
          .toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  static List<ExamProfileModel> filter(
      List<ExamProfileModel> items, ExamFilter filter) {
    return items.where((e) {
      if (filter.category != null && e.category != filter.category) {
        return false;
      }
      if (filter.difficulty != null && e.difficulty != filter.difficulty) {
        return false;
      }
      if (filter.status != null && e.applicationStatus != filter.status) {
        return false;
      }
      if (filter.mode != null && e.mode != filter.mode) return false;
      if (filter.month != null &&
          !e.dateEvents.any((d) => d.date.month == filter.month)) {
        return false;
      }
      if (filter.state != null && e.state != filter.state) return false;
      return true;
    }).toList();
  }

  static List<ExamProfileModel> sort(
      List<ExamProfileModel> items, ExamSortOrder order) {
    final list = List<ExamProfileModel>.from(items);
    switch (order) {
      case ExamSortOrder.relevance:
        break;
      case ExamSortOrder.mostPopular:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
        break;
      case ExamSortOrder.nearestDate:
        list.sort((a, b) {
          final da = a.nextUpcomingEvent?.date;
          final db = b.nextUpcomingEvent?.date;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return da.compareTo(db);
        });
        break;
      case ExamSortOrder.alphabetical:
        list.sort((a, b) => a.shortName.compareTo(b.shortName));
        break;
      case ExamSortOrder.easiestFirst:
        list.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
        break;
    }
    return list;
  }
}
